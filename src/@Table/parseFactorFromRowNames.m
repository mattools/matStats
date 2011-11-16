function res = parseFactorFromRowNames(this, pos1, len, factorName)
%PARSEFACTORFROMROWNAMES Create a factor table by parsing row names
%
%   FACT = parseFactorFromRowNames(THIS, POS1, LEN)
%   FACT = parseFactorFromRowNames(THIS, POS1, LEN, FACTORNAME)
%
%   Example
%   parseFactorFromRowNames
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% compute last position
pos2 = pos1 + len - 1;

% extract factor levels
names = strjust(char(this.rowNames), 'left');
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
    'rowNames', this.rowNames, ...
    'colNames', {factorName}, ...
    'levels', {levels});
