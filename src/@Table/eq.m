function res = eq(this, that)
%EQ  Overload the eq operator for Table objects
%
%   output = eq(input)
%
%   Example
%   eq
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute eq for table with factors');
end

[this that parent names1 names2] = parseInputCouple(this, that);

% compute new data
newData = bsxfun(@eq, this, that);

newColNames = strcat(names1, '==', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
