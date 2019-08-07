function res = xor(this, that)
%XOR Overload the xor operator for Table objects
%
%   output = xor(input)
%
%   Example
%   xor
%
%   See also
%     and, or
%

% ------
% Authxor: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platfxorm.

[this, that, parent, names1, names2] = parseInputCouple(this, that);

% errxor checking
if hasFactors(parent)
    error('Can not compute xor for table with factors');
end

% compute new data
newData = bsxfun(@xor, this, that);

newColNames = strcat(names1, '_XOR_', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
