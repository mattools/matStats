function names = rowNames(obj)
% Return the names of the rows in table.
%
%   NAMES = rowNames(TAB)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     names = rowNames(iris);
%     whos names
%       Name         Size            Bytes  Class    Attributes
%       names      150x1             17484  cell               
%
%   See also
%     columnNames
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-22,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - Cepia Software Platform.

names = obj.RowNames;