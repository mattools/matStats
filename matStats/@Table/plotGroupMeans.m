function varargout = plotGroupMeans(data, group, varargin)
% Plot the mean value of each group.
%
%   output = plotGroupMeans(input)
%
%   Example
%   plotGroupMeans
%
%   See also
%     plot, aggregate

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

ax = gca;

% extraction of groups indices and labels from input table
[groupIndices, levelNames, groupLabel] = parseGroupInfos(group); %#ok<ASGLU>
nLevels = length(levelNames);

means = groupStats(data, group);

h = plot(ax, 1:nLevels, means.Data, varargin{:});
xlim([0 nLevels+1]); 

set(gca, 'xtick', 1:nLevels);
set(gca, 'XTickLabel', levelNames);

xlabel(groupLabel); 
ylabel(''); 

titleString = '';
if isa(data, 'Table')
    titleString = data.ColNames{1};
end
title(titleString);

if nargout > 0
    varargout = {h};
end
