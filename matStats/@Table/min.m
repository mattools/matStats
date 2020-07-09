function res = min(obj, varargin)
% Put the min of each column in a new table.
%
%   output = min(input)
%
%   Example
%   min
%
%   See also
%     max, mean
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute min for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Min of ' obj.Name];
end

res = newInstance(obj, min(obj.Data, [], 1), 'Parent', obj, ...
    'RowNames', {'min'}, ...
    'Name', newName);
    