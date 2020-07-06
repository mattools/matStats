function res = cumsum(obj, varargin)
% Cumulative sum of columns.
%
%   RES = cumsum(TAB)
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     res = cumsum(tab(:, 1:4));
%
%   See also
%     sum, mean, diff

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2017-10-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2017 INRA - Cepia Software Platform.

% check validity
if hasFactors(obj)
    error('MatStats:Table:cumsum', ...
        'Can not compute sum for table with factors');
end

% compute name for result
newName = '';
if ~isempty(obj.Name)
    newName = ['cumsum of ' obj.Name];
end

% create result table
res = Table.create(cumsum(obj.Data, 1), ...
    'RowNames', obj.RowNames, ...
    'ColNames', obj.ColNames, ...
    'Name', newName);
    