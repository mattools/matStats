function res = log2(this)
%LOG2 Binary logarithm of table values
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


if hasFactors(this)
    error('Can not compute log for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['Log2 of ' this.Name];
end

newColNames = strcat('log2', this.ColNames);

res = Table.create(log2(this.Data), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    