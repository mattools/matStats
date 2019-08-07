function res = abs(this)
%ABS Absolute value of data in table
%
%   RES = abs(TAB)
%   Returns table with same row names and column names, but containinf
%   avsolute values of original values.
%
%   Example
%   abs
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute abs for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['abs of ' this.Name];
end

newColNames = strcat('abs', this.ColNames);

res = Table.create(abs(this.Data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    