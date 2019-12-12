function res = mtimes(obj1, obj2)
% Overload the mtimes operator for Table objects.
%
%   output = mtimes(input)
%
%   Example
%   mtimes
%
%   See also
%     mrdivide, plus, minus
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2);

% error checking
if hasFactors(parent)
    error('Can not compute TIMES for table with factors');
end

% compute new data
newData = bsxfun(@times, obj1, obj2);

newColNames = strcat(names1, '*', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
