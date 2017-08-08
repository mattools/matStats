function res = log(this)
%LOG Logarithm of table values
%
%   RES = log(TAB)
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


if hasFactors(this)
    error('Can not compute log for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['Log of ' this.name];
end

newColNames = strcat('log', this.colNames);

res = Table.create(log(this.data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    