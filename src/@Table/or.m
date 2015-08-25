function res = or(this, that)
%OR Overload the or operator for Table objects
%
%   output = or(input)
%
%   Example
%   or
%
%   See also
%   and, ne

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[this, that, parent, names1, names2] = parseInputCouple(this, that);

% error checking
if hasFactors(parent)
    error('Can not compute OR for table with factors');
end

% compute new data
newData = bsxfun(@or, this, that);

newColNames = strcat(names1, '|', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
