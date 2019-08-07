function res = max(this, varargin)
%MAX Put the max of each column in a new table
%
%   output = max(input)
%
%   Example
%   max
%
%   See also
%     min, mean, median
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute max for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['Max of ' this.Name];
end

res = Table.create(max(this.Data, [], 1), ...
    'rowNames', {'max'}, ...
    'colNames', this.ColNames, ...
    'name', newName);
    