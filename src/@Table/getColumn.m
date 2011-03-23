function column = getColumn(this, colName)
%GETROW Extract column data of the table
%
%   output = getColumn(input)
%
%   Example
%   getRow
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-23,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% Parse index of column
ind = this.columnIndex(colName);

% extract data
column = this.data(:, ind);
