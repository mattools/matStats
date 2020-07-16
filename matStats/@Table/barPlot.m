function varargout = barPlot(varargin)
% Bar plot of the table data.
%
%   barPlot(TAB)
%   Simple wrapper to the native "bar" function from Matlab, that also
%   displays appropriate labels and legend.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     res = groupStats(iris(:,1:4), iris(:,5), @mean);
%     figure; barPlot(res)
%     figure; barPlot(res')
%
%   See also
%     linePlot, stairStepsPlot, stemPlot, barweb
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


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


% if plot into an empty axis, make some additional setups. Otherwise, leave
% as is.
decoratePlot = isempty(get(ax, 'Children'));


%% Initialisations

xAxisLabel = '';
xTickLabels = {};

if isempty(tabX)
    % default xData
    xData = 1:size(obj, 1);
else
    % x-axis meta-data are given explicitely as first argument
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

% display the bar
if isempty(tabX)    
    h = bar(ax, tabY.Data, varargin{:});
else
    h = bar(ax, tabX.Data, tabY.Data, varargin{:});
end


%% Decorate plot

if decoratePlot
    % Annotate X axis
    if ~isempty(xTickLabels)
        set(ax, 'XTick', 1:length(xTickLabels));
        set(ax, 'XTickLabel', xTickLabels);
    end
    if ~isempty(xData)
        dx = xData(2) - xData(1);
        xlim = [xData(1)-dx/2 xData(end)+dx/2];
        set(ax, 'XLim', xlim);
    end
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end
    
    % title is the name of the table
    if ~isempty(tabY.Name)
        title(tabY.Name, 'Interpreter', 'none');
    end
    
    % optionally display legend
    if showLegend
        % use column names as legend
        legend(tabY.ColNames, 'Location', legendLocation);
    end
end


%% Process output arguments

% return handle
if nargout > 0
    varargout = {h};
end
