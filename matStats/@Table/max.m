function res = max(this, varargin)
%MAX Put the max of each column in a new table
%
%   output = max(input)
%
%   Example
%   max
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute max for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['Max of ' this.name];
end

res = Table.create(max(this.data, [], 1), ...
    'rowNames', {'max'}, ...
    'colNames', this.colNames, ...
    'name', newName);
    