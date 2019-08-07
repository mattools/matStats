function labels = formatLevelLabels(levels, groupNames, varargin)
%FORMATLEVELLABELS  Replace single labels by "grp=lvl" strings
%
%   LABELS = formatLevelLabels(LEVELS, GROUPLABEL)
%
%   Example
%     iris = Table.read('fisherIris');
%     species = iris('Species');
%     formatLevelLabels(species.levels{1}, {'group'})
%
%   See also
%     parseGroupInfos
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-23,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

labels = levels;
format = '%s=%s';


for iGroup = 1:size(levels, 2)
    groupLabel = groupNames{iGroup};
    
    for iLevel = 1:size(levels, 1)
        level = levels{iLevel, iGroup};
        if isnumeric(level)
            level = num2str(level);
        end
        label = sprintf(format, groupLabel, level);
        labels{iLevel, iGroup} = label;
    end
end

% Concatenate 
if size(labels, 1) > 1
    tmp = labels;
    labels = labels(:, 1);
    for iCol = 2:size(tmp, 2)
        labels = strcat(labels, ';', tmp(:,iCol));
    end
end
