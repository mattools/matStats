function res = abs(obj)
% Absolute value of data in table.
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


if hasFactors(obj)
    error('Can not compute abs for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['abs of ' obj.Name];
end

newColNames = strcat('abs', obj.ColNames);

res = Table.create(abs(obj.Data), ...
    'parent', obj, ...
    'name', newName, ...
    'colNames', newColNames);
    