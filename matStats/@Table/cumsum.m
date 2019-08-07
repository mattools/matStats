function res = cumsum(this, varargin)
%CUMSUM Cumulative sum of columns
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
% e-mail: david.legland@inra.fr
% Created: 2017-10-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2017 INRA - Cepia Software Platform.

% check validity
if hasFactors(this)
    error('MatStats:cumsum:FactorColumn', ...
        'Can not compute sum for table with factors');
end

% compute name for result
newName = '';
if ~isempty(this.Name)
    newName = ['cumsum of ' this.Name];
end

% create result table
res = Table.create(cumsum(this.Data, 1), ...
    'rowNames', this.RowNames, ...
    'colNames', this.ColNames, ...
    'name', newName);
    