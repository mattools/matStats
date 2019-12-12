function val = getValue(obj, row, col)
% Returns the value for the given row and column.
%
%   V = getValue(TAB, R, C)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     val = getValue(iris, 3, 'SepalWidth')
%     val =
%         3.2000
%
%   See also
%     getLevel, subsref

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-10-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% parse indices for row and column
row = rowIndex(obj, row);
col = columnIndex(obj, col);

% return selected value(s)
val = obj.Data(row, col);
