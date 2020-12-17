function res = gt(obj1, obj2)
% Overload the gt operator for Table objects.
%
%   RES = gt(TAB1, TAB2)
%
%   Example
%   gt
%
%   See also
%     eq, le, lt, ge
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2, inputname(1), inputname(2));

% error checking
if hasFactors(parent)
    error('Can not compute gt for table with factors');
end

% compute new data
newData = bsxfun(@gt, obj1, obj2);

% create result array
res = Table.create(newData, ...
    'Parent', parent);

% update column names
colNames = strcat(names1, '>', names2);
if length(colNames) == size(res, 2)
    res.ColNames = colNames;
end
