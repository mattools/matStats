function varargout = scatter(this, varargin)
%SCATTER Scatter plot of table data
%
%   scatter(TAB1, TAB2)
%   Use two tables, with one column each, that respectively specifies the x
%   and y coordinates.
%
%   scatter(TAB, VAR1, VAR2)
%   Scatters the data in the table TAB by using corodinates VAR1 and VAR2.
%   TABLE is a Table object, and VAR1 and VAR2 are either indices or names
%   of 2 columns in the table.
%
%   scatter(..., STYLE)
%   scatter(..., PARAM, VALUE)
%   Specifies drawing options.
%
%   Example
%   % scatter petal length values against petla width
%     iris = Table.read('fisherIris.txt');
%     figure; set(gca, 'fontsize', 14);
%     scatter(iris('PetalWidth'), iris('PetalLength'))
%
%   % scatter petal length values against species
%     iris = Table.read('fisherIris.txt');
%     figure; set(gca, 'fontsize', 14);
%     scatter(iris('Species'), iris('PetalLength'), 's')
%
%   See also
%     plot, scatterNames, scatterGroup
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


if size(this.data, 2) == 1
    % Data are given as one table and two column names/indices
    
    if nargin < 2 || ~isa(varargin{1}, 'Table')
        error(['Table:' mfilename ':NotEnoughArguments'], ...
            'Second argument must be another table');
    end
    
    xdata = this.data(:, 1);
    indx = 1;
    nameX = this.colNames{1};
    
    var = varargin{1};
    ydata = var.data(:, 1);
    nameY = var.colNames{1};
    varargin(1) = [];

else
    % Data are given as one table and two column names/indices
    if nargin < 3 
        error(['Table:' mfilename ':NotEnoughArguments'], ...
            'Need to specify names of x and y columns');
    end
    
    % index of first column
    var1 = varargin{1};
    indx = columnIndex(this, var1);
    xdata = this.data(:, indx(1));
    nameX = this.colNames{indx(1)};

    % index of second column
    var2 = varargin{2};
    indy = columnIndex(this, var2);
    ydata = this.data(:, indy(1));
    nameY = this.colNames{indy(1)};
    
    varargin(1:2) = [];
end

% check if drawing style is ok to plot points
if isempty(varargin)
    varargin = {'+b'};
end

% scatter plot of selected columns
ax = gca;
h = scatter(ax, xdata, ydata, varargin{:});

if isFactor(this, indx(1))
    levels = this.levels{indx(1)};
    if isnumeric(levels)
        set(ax, 'xtick', levels);
        
    else
        nLevels = length(levels);
        set(ax, 'xlim', [.5 nLevels+.5]);
        set(ax, 'xtick', 1:nLevels);
        set(ax, 'xtickLabel', levels);
    end
end


% add plot annotations
xlabel(nameX, 'Interpreter', 'none');
ylabel(nameY, 'Interpreter', 'none');
if ~isempty(this.name)
    title(this.name, 'Interpreter', 'none');
end

% eventually returns handle to graphics
if nargout > 0
    varargout = {h};
end
