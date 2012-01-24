function varargout = plotGroupRows(varargin)
%PLOTGROUPROWS Plot data table rows with different style by group
%
%   plotGroupRows(TAB, GROUP)
%   Plots the rows of the data table TAB, with different color depending on
%   the values in GROUP. GROUP can be:
%   * logical column vector
%   * cell array of strings
%   * data table with one column
%
%   plotGroupRows(X, TAB, GROUP)
%   (later....)
%
%   plotGroupRows(AX, ...)
%
%   Example
%   plotGroupRows
%
%   See also
%     plotRows
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-01-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% determines whether an axis handle is given as argument
[ax this varargin] = parseAxisHandle(varargin{:});

% extract xdata
xdata = 1:size(this, 2);

% extract the group
group = varargin{1};
varargin(1) = [];


groupColors = [0 0 1;1 0 0;0 1 0;1 0 1;0 1 1;.4 .4 .4;0 0 0];

hold on;

if isnumeric(group)
    groupValues = unique(group);
    nGroups = length(groupValues);
    
    h = zeros(nGroups, 1);
    for iGroup = 1:nGroups
        inds = group == groupValues(iGroup);
        hl = plot(ax, xdata, this.data(inds, :)', ...
            'color', groupColors(iGroup, :), varargin{:});
        h(iGroup) = hl(1);
    end
end

groupNames = num2str((1:nGroups)');
legend(h, groupNames);


%% Format output
if nargout > 0
    varargout = {h};
end
