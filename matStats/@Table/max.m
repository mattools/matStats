function res = max(obj, varargin)
% Put the max of each column in a new table.
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


if hasFactors(obj)
    error('Can not compute max for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Max of ' obj.Name];
end

res = newInstance(obj, max(obj.Data, [], 1), 'Parent', obj, ...
    'RowNames', {'max'}, ...
    'Name', newName);
    