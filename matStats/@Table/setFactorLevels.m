function setFactorLevels(this, colName, levels)
%SETFACTORLEVELS Set up the levels of a factor in a table
%
%   setFactorLevels(TAB, COLNAME, LEVELS)
%   TAB is a Table object, and COLNAME is either a column name or index.
%   LEVELS is a cell array of strings containing the name of each level in
%   the given column.
%
%   Example
%     VALS = [10.12 10.23 9.83 10.53 9.98 10.81]';
%     GRP = [1 1 1 2 2 2]';
%     TAB = Table([VALS GRP], {'values', 'group'});
%     TAB.setAsFactor('group');
%     TAB.setFactorLevels('group', {'original', 'modified'}');
%     TAB
%     TAB = 
%              values       group
%     1         10.12    original
%     2         10.23    original
%     3          9.83    original
%     4         10.53    modified
%     5          9.98    modified
%     6         10.81    modified
%
%   See also
%   setAsFactor, hasFactors, trimLevels
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% identify column index from first argument
indCol = columnIndex(this, colName);

% ensures list of levels is a (column) cell array
if ischar(levels)
    levels = cellstr(levels);
end
levels = levels(:);
this.levels{indCol} = levels;

% check there is enough level names
nLevels = length(levels);
nVals = length(unique(this.data(:, indCol)));
if nVals > nLevels
    warning('Table:setFactorLevels',...
        'The number of unique values is greater than the number of levels');
end
