function varargout = scatterNames(varargin)
% Scatter names according to two variables.
%
%   scatterNames(T, COL1, COL2)
%   Scatters row names of table T with respect to coordinates given by
%   columns COL1 and COL2.
%
%   scatterNames(T, COL1, COL2, COLLABELS)
%   Do not scatter row names, but labels gven by the cvolumn 'COLLABELS'.
%
%   scatterNames(T1, T2, NAMES)
%   Scatter coordinates are given by the two tables T1 and T2 (that should
%   have only one column), and names to scatter are given explicitely.
%   
%   Example
%     iris = Table.read('fisherIris.txt');
%     scatterNames(iris, 1, 2);
%
%     scatterNames(iris('PetalLength'), iris('SepalWidth'));
%
%   See also
%     scatter, scatterGroup, plot, text
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-07-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

%% Initialisations

% default values for options
fontSize = 8;
interpreter = 'none';


%% Input controls 

% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

if length(varargin) < 3
    error('Should be called with at least 3 arguments');
end

obj = varargin{1};
varargin(1) = [];


%% Extract coordinates

if size(obj, 2) == 1
    % If input table has only one column, second argument must contain 
    % y-coords
    xData = obj.Data;
    var2 = varargin{2};
    yData = var2.Data(:, 1);
    varargin(1) = [];
    
    xlabelText = obj.ColNames{1};
    ylabelText = var2.ColNames{1};
    
else
    % If input table has more than one column, second and third arguments
    % must provide column names
    indx = columnIndex(obj, varargin{1});
    indy = columnIndex(obj, varargin{2});
    varargin(1:2) = [];

    xData = obj.Data(:,indx);
    yData = obj.Data(:,indy);
    
    labels = obj.RowNames;
    
    xlabelText = obj.ColNames{indx};
    ylabelText = obj.ColNames{indy};
end


% check if naxt argument contains labels as a cell array
if ~isempty(varargin)
    var1 = varargin{1};
    if iscell(var1)
        labels = var1;
        varargin(1) = [];
    end
end


%% Extract drawing options

% parse optional arguments
options = {};
while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'fontsize'
            fontSize = varargin{2};
        case 'interpreter'
            interpreter = varargin{2};
        case 'xlabel'
            xlabelText = varargin{2};
        case 'ylabel'
            ylabelText = varargin{2};
        otherwise
            % assumes these are options for the 'text' function
            options = [options {paramName, varargin{2}}]; %#ok<AGROW>
    end

    varargin(1:2) = [];
end


%% Plot

% scatter selected labels
plot(ax, xData, yData, 'w.');
h = text(xData, yData, labels, 'Parent', ax, 'FontSize', fontSize, options{:});

% add plot annotations
xlabel(xlabelText);
ylabel(ylabelText);

if ~isempty(obj.Name)
    title(obj.Name, 'Interpreter', interpreter);
end


%% Output

% eventually returns handle to graphics
if nargout > 0
    varargout = {h};
end
