function res = round(this)
%ROUND Round values in the table
%
%   RES = round(TAB)
%   Returns a new table with rounded values.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     round(iris(1:3, 1:4))
%     ans =
%              SepalLength    SepalWidth    PetalLength    PetalWidth
%         1              5             4              1             0
%         2              5             3              1             0
%         3              5             3              1             0
%
%   See also
%     ceil, floor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if hasFactors(this)
    error('Can not round table with factors');
end

newData = round(this.data);

res = Table(newData, 'parent', this);
