function val = getValue(this, row, col)
%GETVALUE Returns the value for the given row and column
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
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-10-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% parse indices for row and column
row = rowIndex(this, row);
col = columnIndex(this, col);

% return selected value(s)
val = this.data(row, col);
