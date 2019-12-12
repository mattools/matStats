function varargout = plotGroupRows(varargin)
% Plot data table rows with different style by group.
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
%     plotRows, plot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-01-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% determines whether an axis handle is given as argument
[ax, varargin] = parseAxisHandle(varargin{:});

% assumes first input argument is the current table
obj = varargin{1};
varargin(1) = [];

% extract the group
group = varargin{1};
varargin(1) = [];


% check if the argument specifying the x data is given
xdata = [];
if ~isempty(varargin)
    var = varargin{1};
    if ~ischar(var)
        % 'shift' variables
        xdata   = obj;
        obj    = group;
        group   = var;
    end
end

% compute xdata if it was not defined
if isempty(xdata)
    % default xdata is a linear vector between 1 and nCols
    xdata = 1:size(obj, 2);

    % try to parse column names as input vectors
    vals = str2num(char(obj.ColNames')); %#ok<ST2NM>
    if length(vals) == size(obj, 2)
        xdata = vals;
    end

end


% default colors for groups
groupColors = [0 0 1;1 0 0;0 1 0;1 0 1;0 1 1;.4 .4 .4;0 0 0];
nColors = size(groupColors, 1);


%% Display curves corresponding to each group


% extraction of groups indices and labels from input table
[groupIndices, groupLabels, groupNames] = parseGroupInfos(group);
groupLabels = formatLevelLabels(groupLabels, groupNames); 

groupNames = groupLabels;
nGroups = length(groupNames);

% allocate memory
h = zeros(nGroups, 1);

% prepare display
hold on;

for iGroup = 1:nGroups
    inds = groupIndices == iGroup;
    
    color = groupColors(mod(iGroup-1, nColors)+1, :);
    hl = plot(ax, xdata, obj.Data(inds, :)', ...
        'color', color, ...
        varargin{:});
    h(iGroup) = hl(1);
end

legend(h, groupNames);
    

%% Format output
if nargout > 0
    varargout = {h};
end
