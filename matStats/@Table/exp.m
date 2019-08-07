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
%     log, sqrt

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute exp for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['Exp of ' this.Name];
end

newColNames = strcat('exp', this.ColNames);

res = Table.create(exp(this.Data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    