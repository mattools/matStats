function names = columnNames(obj)
%COLUMNNAMES Return the names of the columns in table.
%
%   NAMES = columnNames(TAB)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     columnNames(iris)
%     ans =
%       1x5 cell array
%         {'SepalLength'}    {'SepalWidth'}    {'PetalLength'}    {'PetalWidth'}    {'Species'}
%
%   See also
%     rowNames
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-22,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - Cepia Software Platform.

names = obj.ColNames;