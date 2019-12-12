function res = parseFactorFromRowNames(obj, pos1, len, factorName)
% Create a factor table by parsing row names.
%
%   FACT = parseFactorFromRowNames(THIS, POS1, LEN)
%   FACT = parseFactorFromRowNames(THIS, POS1, LEN, FACTORNAME)
%
%   Example
%   parseFactorFromRowNames
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% ensure row names exist
if isempty(obj.RowNames)
    error('Table:parseFactorFromRowNames', ...
        'requires valid row names');
end

% ensure valid name for column
if nargin < 4
    factorName = 'group';
end

% compute last position
pos2 = pos1 + len - 1;

% extract factor levels
names = strjust(char(obj.RowNames), 'left');
if size(names, 2) < pos2
    error('Table:parseFactorFromRowNames', ...
        'row names array do not have enough characters');
end
names = names(:, pos1:pos2);

% keep unique level instances
[levels, m, indices] = unique(names, 'rows'); %#ok<ASGLU>
levels = cellstr(levels)';

% create result table
res = Table.create(indices, ...
    'rowNames', obj.RowNames, ...
    'colNames', {factorName}, ...
    'levels', {levels}, ...
    'name', obj.Name);
