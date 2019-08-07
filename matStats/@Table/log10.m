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
%     log, log2, sqrt
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute log10 for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['log10 of ' this.Name];
end

newColNames = strcat('log10', this.ColNames);

res = Table.create(log10(this.Data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    