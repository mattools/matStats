function [groupIndices groupNames] = indexGroupValues(group)
%INDEXGROUPVALUES  Return indices and names of group in a variable
%
%   output = indexGroupValues(input)
%
%   Example
%   indexGroupValues
%
%   See also
%   parseGroupInfos
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

warning('Table:deprecated', ...
    'function "indexGroupValues" is deprecated, use "parseGroupInfos" instead');

if isnumeric(group)
    % group can be given as a numeric column vector
    [groupNames pos groupIndices] = unique(group); %#ok<ASGLU>
    
elseif isa(group, 'Table')
    % group can be a table, possibly with factor
    if size(group, 2) > 1
        error('Group Table should have only one column');
    end
    
    if isFactor(group, 1)
        levels = group.levels{1};
        [groupNames pos groupIndices] = unique(levels(group.data)); %#ok<ASGLU>
        
    else
        [groupNames pos groupIndices] = unique(group.data, 'rows'); %#ok<ASGLU>
    end
    
elseif iscell(group)
    % group can also be a cell array of strings
    [groupNames pos groupIndices] = unique(group); %#ok<ASGLU>
    
end

if isnumeric(groupNames)
    groupNames = cellstr(num2str(groupNames));
end
