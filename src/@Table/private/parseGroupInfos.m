function [groupIndices levelNames labels] = parseGroupInfos(group)
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
%   The output variable LEVELS is a NG-by-1 cell array containing the name
%   or the numeric value of each group. 
%
%   [INDICES NAMES LABEL] = parseGroupInfos(GROUP)
%   Also return the label of the group, that correspond either to the
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
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if isnumeric(group)
    % group can be given as a numeric column vector
    [levelNames pos groupIndices] = unique(group, 'rows'); %#ok<ASGLU>
    labels = {inputname(1)};
    
elseif iscell(group)
    % group can also be a cell array of strings (column vector, row vector
    % tolered)
    if min(size(group)) > 1
        error('Cell arrays of group levels must be a column vector');
    end
    [levelNames pos groupIndices] = unique(group(:)); %#ok<ASGLU>
    labels = {inputname(1)};
    
elseif isa(group, 'Table')
    % group can be a table, possibly with factor

    [nameIndices pos groupIndices] = unique(group.data, 'rows'); %#ok<ASGLU>

    levelNames = cell(size(nameIndices));
    for iGroup = 1:size(levelNames, 2)
        if isFactor(group, iGroup)
            % in case of factor, extract stored levels
            levelInds = unique(nameIndices(:,iGroup));
            levels = group.levels{iGroup};
            if length(levelInds) > length(levels)
                error('Not enough level names for factor data');
            end
            
        else
            % in case of numeric variable, create cell array from numeric
            % levels, and update name indices
            [levelInds pos inds] = unique(nameIndices(:,iGroup)); %#ok<ASGLU>
            
            nameIndices(:,iGroup) = inds;
            levels = strtrim(cellstr(num2str(levelInds)));
        end
        
        % associate each level index to level name
        for iLevel = 1:length(levelInds)
            % find indices
            inds = nameIndices(:,iGroup) == iLevel;
           
            % associate name to index
            levelNames(inds, iGroup) = levels(iLevel);
        end
        
    end
    
    labels = group.colNames;
    
end
