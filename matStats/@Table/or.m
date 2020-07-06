function res = or(obj1, obj2)
% Overload the or operator for Table objects.
%
%   RES = or(TAB1, TAB2)
%
%   Example
%   or
%
%   See also
%     and, ne
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2);

% error checking
if hasFactors(parent)
    error('Can not compute OR for table with factors');
end

% compute new data
newData = bsxfun(@or, obj1, obj2);

colNames = strcat(names1, '|', names2);

% create result array
res = Table.create(newData, ...
    'Parent', parent, ...
    'ColNames', colNames);
