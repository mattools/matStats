function res = floor(obj)
% Floor values in the table.
%
%   RES = floor(TAB)
%   Returns a new table with floored values.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     floor(iris(1:3, 1:4))
%     ans =
%              SepalLength    SepalWidth    PetalLength    PetalWidth
%         1              5             3              1             0
%         2              4             3              1             0
%         3              4             3              1             0
%
%   See also
%     round, ceil
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if hasFactors(obj)
    error('Can not floor table with factors');
end

newData = floor(obj.Data);

res = Table(newData, 'parent', obj);
