function setFactorLevels(this, colName, levels)
%SETFACTORLEVELS Set up the levels of a factor in a table
%
%   setFactorLevels(TAB, COLNAME, LEVELS)
%   TAB is a Table object, and COLNAME is either a column name or index.
%   LEVELS is a cell array of strings containing the name of each level in
%   the given column.
%
%   Example
%   setFactorLevels
%
%   See also
%   setAsFactor, hasFactors
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

indCol = columnIndex(this, colName);

this.levels{indCol} = levels;

% check there is enough level names
nVals = length(unique(this.data(:, indCol)));
nLevels = length(levels);
if nVals > nLevels
    warning('Table:setFactorLevels',...
        'The number of unique values is greater to the number of levels');
end
