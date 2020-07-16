function varargout = plot(varargin)
% Plot the content of a column.
%
%   Syntax
%   plot(TAB)
%   Plot all columns in table TAB
%
%   plot(TABX, TAB)
%   Plot all columns in table TAB, using TABX as input for x values. TABX
%   must have only one column.
%
%   Description
%   Plot the content of the column specified by COL. COL can be either an
%   index, or a column name.
%
%   Example
%
%   See also
%     plotRows, bar, stairs, stem, scatter
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

% extract calling table
obj = varargin{1};
varargin(1) = [];

% default tables for plotting
tabX = [];
tabY = obj;

% if two inputs are specified, setup the tabX variable
if ~isempty(varargin)
    if isa(varargin{1}, 'Table')
        tabX = obj;
        tabY = varargin{1};
        varargin(1) = [];
    end
end

% parse legend location info
legendLocation = 'NorthEast';
ind = find(cellfun(@(x)strcmpi(x, 'LegendLocation'), varargin), 1);
if ~isempty(ind)
    legendLocation = varargin{ind+1};
    varargin(ind:ind+1) = [];
end


%% Initialisations

xData = [];
xAxisLabel = '';
xTickLabels = {};

if ~isempty(tabX)
    if isa(tabX, 'Table')
        xData = tabX.Data(:, 1);
        
        xAxisLabel = tabX.ColNames{1};
        if isFactor(tabX, 1)
            xTickLabels = tabX.Levels{1};
        end
    else
        xData = tabX;
    end
end


%% Plot data

if isempty(tabX)
    % plot(Y)
    types = tabY.PreferredPlotTypes;
    switch lower(types{1})
        case 'line'
            h = linePlot(ax, tabY, varargin{:});
        case 'stairsteps'
            h = stairStepsPlot(ax, tabY, varargin{:});
        case 'stem'
            h = stemPlot(ax, tabY, varargin{:});
        case 'bar'
            h = barPlot(ax, tabY, varargin{:});
        otherwise
            error('MatStats:Table:plot', ['Unknown plot type: ' types{1}]);
    end
    
else
    % plot(X, Y)
    types = tabY.PreferredPlotTypes;
    switch lower(types{1})
        case 'line'
            h = linePlot(ax, xData, tabY, varargin{:});
        case 'stairsteps'
            h = stairStepsPlot(ax, xData, tabY, varargin{:});
        case 'stem'
            h = stemPlot(ax, xData, tabY, varargin{:});
        case 'bar'
            h = barPlot(ax, xData, tabY, varargin{:});
        otherwise
            error('MatStats:Table:plot', ['Unknown plot type: ' types{1}]);
    end
    
    % Annotate X axis
    if ~isempty(xTickLabels)
        set(ax, 'XTick', 1:length(xTickLabels));
        set(ax, 'XTickLabel', xTickLabels);
        set(ax, 'XLim', [0 length(xTickLabels)]+.5);
    end
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end

end

 
%% Graph decoration

% title is the name of the table
if ~isempty(tabY.Name)
    title(tabY.Name, 'Interpreter', 'none');
end

% use column names as legend
legend(tabY.ColNames, 'Location', legendLocation);


%% Format output
if nargout > 0
    varargout = {h};
end
