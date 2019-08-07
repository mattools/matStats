function column = getColumn(this, colName)
%GETCOLUMN Extract column data of the table
%
%   COL = getColumn(TABLE, COLNAME)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     col = getColumn(iris, 'SepalLength');
%     whos('col')
%       Name        Size            Bytes  Class     Attributes
%       col       150x1              1200  double              
%
%   See also
%     getRow

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-23,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% Parse index of column
ind = this.columnIndex(colName);

% extract data
column = this.Data(:, ind);
