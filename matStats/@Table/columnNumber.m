function n = columnNumber(this)
%COLUMNNUMBER Number of columns in the table
%
%   IND = columnNumber(TABLE)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     columnNumber(iris)
%     ans = 
%          5
%
%   See also
%     rowNumber

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

n = size(this.Data, 2);
