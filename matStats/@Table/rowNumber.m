function n = rowNumber(obj)
% Number of rows in the table.
%
%   IND = rowNumber(TABLE)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     rowNumber(iris)
%     ans = 
%          150
%
%   See also
%     columnNumber
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

n = size(obj.Data, 1);
