function varargout = plotRows(varargin)
%PLOTROWS Plot all the rows of the data table
%
%   plotRows(TAB)
%
%   Example
%   plotRows
%
%   See also
%     plot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% determines whether an axis handle is given as argument
[ax, varargin] = parseAxisHandle(varargin{:});

% assumes first input argument is the current table
this = varargin{1};
varargin(1) = [];

% default tables for plotting
tabX = [];
tabY = this;

% if two inputs are specified, setup the tabX variable
if ~isempty(varargin)
    if isa(varargin{1}, 'Table')
        tabX = this;
        tabY = varargin{1};
        varargin(1) = [];
    end
end

% default xData values
xData = [];
xAxisLabel = '';

% compute xdata, either from ydata, or from first input argument
if ~isempty(tabX)
    if isa(tabX, 'Table')
        xData = tabX.Data(:, 1);
        xAxisLabel = tabX.ColNames{1};
    else
        % x data is given as numerical array
        xData = tabX;
    end
    
    % check input sizes are consistent
    if length(xData) ~= size(tabY, 2)
        error('Dimension of input arguments are not consistent');
    end
    
else
    % try to parse column names of input table
    vals = str2num(char(tabY.ColNames')); %#ok<ST2NM>
    if length(vals) == size(tabY, 2)
        xData = vals;
    end
end


%% parse additional input arguments

showLegend = true;
legendLocation = 'NorthEast';

ind = find(strcmpi(varargin(1:2:end), 'legendLocation'));
if ~isempty(ind)
    legendLocation = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end
ind = find(strcmpi(varargin(1:2:end), 'showLegend'));
if ~isempty(ind)
    showLegend = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end

%% Plot data

if isempty(xData)
    % plot(Y)
    h = plot(ax, tabY.Data', varargin{:});
    
else
    % plot(X, Y)
    h = plot(ax, xData, tabY.Data', varargin{:});
    
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end
end


% title is the name of the table
if ~isempty(tabY.Name)
    title(tabY.Name, 'Interpreter', 'none');
end

if min(size(tabY.Data)) > 1 && showLegend
    % When several curves are drawn, display a legend
    legend(tabY.RowNames, 'Location', legendLocation);
else
    % otherwise, use only the first column or row as ylabel
    ylabel(tabY.RowNames{1});
end


%% Format output
if nargout > 0
    varargout = {h};
end
