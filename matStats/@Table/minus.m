function res = minus(obj1, obj2)
% Overload the minus operator for Table objects.
%
%   RES = TAB1 - TAB2;
%   RES = minus(TAB1, TAB2);
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     head(iris(:, 1) - iris(:,2))
%     ans = 
%              SepalLength-SepalWidth
%              ----------------------
%     1                           1.6
%     2                           1.9
%     3                           1.5
%     4                           1.5
%     5                           1.4
%     6                           1.5
%
%   See also
%     plus, times, mrdivide
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2);

% error checking
if hasFactors(parent)
    error('Can not compute MINUS for table with factors');
end

% compute new data
newData = bsxfun(@minus, obj1, obj2);

% create result array
res = Table.create(newData, ...
    'Parent', parent);

colNames = strcat(names1, '-', names2);
if length(colNames) == size(res, 2)
    res.ColNames = colNames;
end

