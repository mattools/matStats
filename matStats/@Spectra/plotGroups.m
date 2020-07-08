function varargout = plotGroups(varargin)
%PLOTGROUP222  One-line description here, please.
%
%   output = plotGroups(input)
%
%   Example
%   plotGroups
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-07-06,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


%% Parse input arguments 

% determines whether an axis handle is given as argument
[ax, varargin] = parseAxisHandle(varargin{:});

% assumes first input argument is the Spectra object
obj = varargin{1};
if ~isa(obj, 'Spectra')
    error('Requires first argument to be a Spectra object');
end
varargin(1) = [];

% extract the group
group = varargin{1};
% if ~isa(group, 'Table')
%     error('Requires second argument to be a Table object');
% end
varargin(1) = [];

% if plot into an empty axis, make some additional setups. Otherwise, leave
% as is.
decoratePlot = isempty(get(ax, 'Children'));


%% Parse additional input arguments

% display legend only for small number of rows
showLegend = true;
ind = find(strcmpi(varargin(1:2:end), 'showLegend'));
if ~isempty(ind)
    showLegend = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end

% display legend in top-right corner
legendLocation = 'NorthEast';
ind = find(strcmpi(varargin(1:2:end), 'legendLocation'));
if ~isempty(ind)
    legendLocation = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end


%% Init 

xdata = obj.XValues;

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


%% Plot annotations

if decoratePlot
    % setup axis bounds
    xlim(xdata([1 end]));

    % decorate plot
    if ~isempty(obj.AxisNames)
        if ~isempty(obj.AxisNames{2})
            xlabel(obj.AxisNames{2});
        end
    end

    % use the 'name' property as title
    if ~isempty(obj.Name)
        title(obj.Name, 'Interpreter', 'none');
    end

    if showLegend
        legend(h, groupNames, 'Location', legendLocation);
    end
end


%% Format output
if nargout > 0
    varargout = {h};
end
