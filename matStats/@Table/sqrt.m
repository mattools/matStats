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
%     power, log
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute sqrt for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['sqrt of ' this.Name];
end

newColNames = strcat('sqrt', this.ColNames);

res = Table.create(sqrt(this.Data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    