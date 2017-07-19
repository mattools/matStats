function n = columnNumber(this)
%COLUMNNUMBER Number of columns in the table
%
%   IND = TABLE.columnNumber()
%
%   Example
%   columnIndex
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

n = size(this.data, 2);
