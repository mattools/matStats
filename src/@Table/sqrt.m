function res = sqrt(this)
%SQRT Square root of table values
%
%   RES = sqrt(TAB)
%   Returns table with same row names and column names, but whose values
%   are the sqrtarithms of the values in the table.
%
%   Example
%   sqrt
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
    error('Can not compute sqrt for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['sqrt of ' this.name];
end

newColNames = strcat('sqrt', this.colNames);

res = Table.create(sqrt(this.data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    