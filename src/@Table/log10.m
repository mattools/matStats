function res = log10(this)
%LOG10 Decimal logarithm of table values
%
%   RES = log10(TAB)
%   Returns table with same row names and column names, but whose values
%   are the log10arithms of the values in the table.
%
%   Example
%   log10
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
    error('Can not compute log10 for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['log10 of ' this.name];
end

newColNames = strcat('log10', this.colNames);

res = Table.create(log10(this.data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    