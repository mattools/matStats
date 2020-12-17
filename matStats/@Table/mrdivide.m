function res = mrdivide(obj1, obj2)
% Overload the mrdivide operator for Table objects.
%
%   output = mrdivide(input)
%
%   Example
%   mrdivide
%
%   See also
%     times, plus, minus
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2);

% error checking
if hasFactors(parent)
    error('Can not compute MRDIVIDE for table with factors');
end

% compute new data
newData = bsxfun(@rdivide, obj1, obj2);

% create result array
res = Table.create(newData, ...
    'Parent', parent);

% update column names
colNames = strcat(names1, '/', names2);
if length(colNames) == size(res, 2)
    res.ColNames = colNames;
end
