function level = getLevel(obj, row, col)
% Return the factor level for specified row and column.
%
%   output = getLevel(input)
%
%   Example
%     % Returns level a single row as char or numeric value
%     iris = Table.read('fisherIris.txt');
%     lev = getLevel(iris, 3, 'Species')
%     lev =
%     Setosa
%
%     % Returns level of several rows as a cell array
%     lev = getLevel(iris, 3:5, 'Species')
%     lev =
%         'Setosa'
%         'Setosa'
%         'Setosa'
% 
%   See also
%       getValue, subsref

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-10-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% extract column index
col = columnIndex(obj, col);
if length(col) ~= 1
    error('Table:getLevel:TooManyIndices', ...
        'Requires a single column indicator');
end

% extract levels for the selected column
if length(obj.Levels) < col || isempty(obj.Levels{col})
    error('Table:getLevel:NotAFactor', ...
        'Selected column is not a factor');
end
levels = obj.Levels{col};

row = rowIndex(obj, row);
inds = obj.Data(row, col);

if length(row) == 1
    level = levels{inds};
else
    level = levels(inds);
end

