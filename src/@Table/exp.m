function res = exp(this)
%EXP Exponential of table values
%
%   RES = exp(TAB)
%   Returns table with same row names and column names, but whose values
%   are the exparithms of the values in the table.
%
%   Example
%   exp
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
    error('Can not compute exp for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['Exp of ' this.name];
end

newColNames = strcat('exp', this.colNames);

res = Table.create(exp(this.data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    