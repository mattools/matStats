function res = plus(obj1, obj2)
% Overload the plus operator for Table objects.
%
%   RES = TAB1 + TAB2;
%   RES = plus(TAB1, TAB2);
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     head(iris(:, 1) + iris(:,2))
%     ans = 
%              SepalLength+SepalWidth
%     1                           8.6
%     2                           7.9
%     3                           7.9
%     4                           7.7
%     5                           8.6
%     6                           9.3
%
%   See also
%     minus, times, mrdivide
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2);

% error checking
if hasFactors(parent)
    error('Can not compute PLUS for table with factors');
end

% compute new data
newData = bsxfun(@plus, obj1, obj2);

newColNames = strcat(names1, '+', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
