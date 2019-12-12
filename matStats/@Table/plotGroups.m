function varargout = plotGroups(obj, group, varargin)
% Display obj ordererd by their group levels.
%
%   plotGroups(DATA, GROUP)
%   DATA should be one-dimensional.
%
%   Example
%     % Display sepal length by group
%     iris = Table.read('fisherIris.txt');
%     plotGroups(iris('SepalLength'), iris('Species'), 'x')
%
%   See also
%    plot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

ax = gca;

[groupIndices, levelNames, groupLabel] = parseGroupInfos(group);
nLevels = length(levelNames);

titleString = '';
if isa(obj, 'Table')
    titleString = obj.ColNames{1};
    data = obj.Data;
else
    data = obj;
end

h = plot(ax, groupIndices, data, varargin{:});
xlim([0 nLevels+1]); 

set(gca, 'xtick', 1:nLevels);
set(gca, 'XTickLabel', levelNames);

xlabel(groupLabel); 
ylabel(''); 
title(titleString);

if nargout > 0
    varargout = {h};
end
