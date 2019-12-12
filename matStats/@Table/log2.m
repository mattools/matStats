function res = log2(obj)
% Binary logarithm of table values.
%
%   RES = log2(TAB)
%   Returns table with same row names and column names, but whose values
%   are the logarithms of the values in the table.
%
%   Example
%   log
%
%   See also
%     log, log10, sqrt
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute log for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Log2 of ' obj.Name];
end

newColNames = strcat('log2', obj.ColNames);

res = Table.create(log2(obj.Data), ...
    'parent', obj, ...
    'name', newName, ...
    'colNames', newColNames);
    