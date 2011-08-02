function res = log2(this)
%LOG Binary logarithm of table values
%
%   RES = log2(TAB)
%   Returns table with same row names and column names, but whose values
%   are the logarithms of the values in the table.
%
%   Example
%   log
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute log for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['Log2 of ' this.name];
end

newColNames = strcat('log2', this.colNames);

res = Table.create(log2(this.data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    