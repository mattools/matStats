function res = not(this)
%NOT Invert logical values of table
%
%   RES = not(TAB)
%   Returns table with same row names and column names, but whose values
%   are 1-complemented.
%
%   Example
%   not
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
    error('Can not compute not for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['not of ' this.name];
end

newColNames = strcat('not', this.colNames);

res = Table.create(not(this.data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    