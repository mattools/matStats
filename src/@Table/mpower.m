function res = mpower(this, that)
%MPOWER Overload the mpower operator for Table objects
%
%   output = mpower(input)
%
%   Example
%   mpower
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% error checking
if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute gt for table with factors');
end

[this that parent names1 names2] = parseInputCouple(this, that);

newData = bsxfun(@power, this, that);

newColNames = strcat(names1, '^', names2);

res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
