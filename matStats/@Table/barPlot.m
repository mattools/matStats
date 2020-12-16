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
%     barPlot(res')
%
%   See also
%     barweb, linePlot, stairStepsPlot, stemPlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Process input arguments

% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

% replaces table by its data
ind = cellfun('isclass', varargin, 'Table');
obj = varargin{ind};
varargin(ind) = [];

% parse optional parameters
[showLegend, varargin] = parseInputOption(varargin, 'ShowLegend', size(obj, 2) < 10);
[legendLocation, varargin] = parseInputOption(varargin, 'LegendLocation', 'NorthEast');


%% Display

% display the bar
h = bar(ax, obj.Data, varargin{:});

% format figure
if ~isempty(obj.RowNames)
    set(gca, 'XTickLabel', obj.RowNames);
end

% optionally display legend
if showLegend
    % use column names as legend
    legend(obj.ColNames, 'Location', legendLocation);
end


%% Process output arguments

% return handle
if nargout > 0
    varargout = {h};
end
