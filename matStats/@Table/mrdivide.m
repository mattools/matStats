function res = mrdivide(this, that)
%MRDIVIDE Overload the mrdivide operator for Table objects
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

[this, that, parent, names1, names2] = parseInputCouple(this, that);

% error checking
if hasFactors(parent)
    error('Can not compute MRDIVIDE for table with factors');
end

% compute new data
newData = bsxfun(@rdivide, this, that);

newColNames = strcat(names1, '/', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);

