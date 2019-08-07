function [groupIndices, levelNames, labels] = parseGroupInfos(group)
%PARSEGROUPINFOS Return indices and names of group in a variable
%
%   [INDICES LEVELS] = parseGroupInfos(GROUP)
%   Extract group indices and names from the input GROUP. The input GROUP
%   can be either:
%   * a cell array of values
%   * a numeric array
%   * a data table (assuming factor columns)
%   The output variable INDICES is a N-by-1 column vector containing index
%   of corresponding group for each row.
%   The output variable LEVELS is a NL-by-NG cell array containing the name
%   or the numeric value of each level, with NL being the total number of
%   levels, and NG being the number of groups or factors given as input.
%   The number of levels is determined by the input GROUP. If GROUP is a
%   numeric vector, the number of levels if the number of unique values. If
%   group is a single column factor table, the number of levels is the
%   number of levels of this group. If GROUP is a combination of two
%   factors, the number of levels is the product of the number of levels of
%   each factor.
%
%   [INDICES LEVELS LABEL] = parseGroupInfos(GROUP)
%   Also returns the label of the group, that correspond either to the
%   variable name, or to the column name of the data table.
%
%
%   Example
%   [INDS LEVELS] = parseGroupInfos([2 3 2 5 3]')
%   INDS = 
%       1
%       2
%       1
%       3
%       2
%   LEVELS =
%         [2]
%         [3]
%         [5]
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if isnumeric(group)
    % group can be given as a numeric column vector
    [levelNames, pos, groupIndices] = unique(group, 'rows'); %#ok<ASGLU>
    levelNames = strtrim(cellstr(num2str(levelNames)));
    labels = {inputname(1)};
    
elseif iscell(group)
    % group can also be a cell array of strings (column vector, row vector
    % tolered)
    if min(size(group)) > 1
        error('Cell arrays of group levels must be a column vector');
    end
    [levelNames, pos, groupIndices] = unique(group(:)); %#ok<ASGLU>
    labels = {inputname(1)};
    
elseif isa(group, 'Table')
    % group can be a table, possibly with factor

    [groupValues, pos, groupIndices] = unique(group.Data, 'rows'); %#ok<ASGLU>

    levelNames = cell(size(groupValues));
    for iGroup = 1:size(levelNames, 2)
        if isFactor(group, iGroup)
            % in case of factor, extract stored level values
            levelValues = unique(groupValues(:,iGroup));
            levelLabels = group.Levels{iGroup};
            if length(levelValues) > length(levelLabels)
                error('Not enough level names for factor data');
            end
            
        else
            % in case of numeric variable, create cell array from numeric
            % levels, and update name indices
            levelValues = unique(groupValues(:,iGroup));
            
%             groupValues(:,iGroup) = inds;
            levelLabels = strtrim(cellstr(num2str(levelValues)));
        end
        
        % associate each level index to level name
        for iLevel = 1:length(levelValues)
            % index of current level
            value = levelValues(iLevel);
            
            % find indices
            inds = groupValues(:,iGroup) == value;
           
            % associate name to index
            levelNames(inds, iGroup) = levelLabels(iLevel);        
            
%             % index of current level
%             index = levelInds(iLevel);
%             
%             % find indices
%             inds = nameIndices(:,iGroup) == index;
%            
%             % associate name to index
%             levelNames(inds, iGroup) = levels(index);

        end
        
    end
    
    labels = group.ColNames;
    
end
