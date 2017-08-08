function res = ceil(this)
%CEIL Ceil values in the table
%
%   RES = ceil(TAB)
%   Returns a new table with ceiled values.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     ceil(iris(1:3, 1:4))
%     ans =
%              SepalLength    SepalWidth    PetalLength    PetalWidth
%         1              6             4              2             1
%         2              5             3              2             1
%         3              5             4              2             1
%
%   See also
%     round, floor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if hasFactors(this)
    error('Can not ceil table with factors');
end

newData = ceil(this.data);

res = Table(newData, 'parent', this);
