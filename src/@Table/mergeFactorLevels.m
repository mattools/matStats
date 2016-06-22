function this = mergeFactorLevels(this, colName, levelsToMerge, varargin)
%MERGEFACTORLEVELS Merge several levels of a factor
%
%   mergeFactorLevels(TAB, COLNAME, LEVELS, NEWNAME)
%   TAB:        the Table object
%   COLNAME:    the name of the column containing the factors
%   LEVELS:     a cell array containing the names of the levels to merge
%   NEWNAME:    the new level after merging
%
%   Example
%   mergeFactorLevels
%
%   See also
%      setFactorLevels, trimLevels
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-06-22,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - Cepia Software Platform.

% index of current column
indCol = columnIndex(this, colName);

% levels of the factor
colLevels = this.levels{indCol};
levelToMergeInds = find(ismember(colLevels, levelsToMerge));
refLevelInd = levelToMergeInds(1);

% compute name of the new level
if ~isempty(varargin)
    newName = varargin{1};
else
    newName = colLevels{refLevelInd};
end

% change level index of concerned rows
rowInds = ismember(this.data(:, indCol), levelToMergeInds);
this.data(rowInds, indCol) = refLevelInd;

% update list of levels
colLevels{refLevelInd} = newName;

% trim levels
inds0 = this.data(:, indCol);

% find unique indices. New indices are given by J
[uniqueInds, I, J] = unique(inds0); %#ok<ASGLU>

% update result within table
this.data(:, indCol) = J;
this.levels{indCol} = colLevels(uniqueInds);
