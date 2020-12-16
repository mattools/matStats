function varargout = linePlot(varargin)
% Plot the content of a column as continuous lines.
%
%   Syntax
%   linePlot(TAB)
%   Plot all columns in table TAB
%
%   linePlot(TABX, TAB)
%   Plot all columns in table TAB, using TABX as input for x values. TABX
%   must have only one column.
%
%   Description
%   Plot the content of the column specified by COL. COL can be either an
%   index, or a column name.
%
%   Example
%     % line plot of a sinus curve
%     t = linspace(0, 2*pi, 100)';
%     data = [t cos(t) sin(t)];
%     tab = Table(data, {'t', 'cos(t)', 'sin(t)'});
%     figure; linePlot(tab(:,1), tab(:,2:3));
%
%   See also
%     plotRows, barPlot, stairStepsPlot, stemPlot, scatter
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

% parse optional parameters
[showLegend, varargin] = parseInputOption(varargin, 'ShowLegend', size(obj, 2) < 10);
[legendLocation, varargin] = parseInputOption(varargin, 'LegendLocation', 'NorthEast');


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
    h = plot(ax, tabY.Data, varargin{:});
    
else
    % plot(X, Y)
    h = plot(ax, xData, tabY.Data, varargin{:});
    
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

% optionally display legend
if showLegend
    % use column names as legend
    legend(tabY.ColNames, 'Location', legendLocation);
end


%% Format output
if nargout > 0
    varargout = {h};
end
