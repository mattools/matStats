function res = sum(this, varargin)
%SUM Put the sum of each column in a new table
%
%   RES = sum(TAB)
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     res = sum(tab(:, 1:4))
%     res = 
%                SepalLength    SepalWidth    PetalLength    PetalWidth
%     sum              876.5         458.6          563.7         179.9
% 
%
%   See also
%     mean, plus

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check validity
if hasFactors(this)
    error('MatStats:sum:FactorColumn', ...
        'Can not compute sum for table with factors');
end

% compute name for result
newName = '';
if ~isempty(this.name)
    newName = ['Sum of ' this.name];
end

% create result table
res = Table.create(sum(this.data, 1), ...
    'rowNames', {'sum'}, ...
    'colNames', this.colNames, ...
    'name', newName);
    