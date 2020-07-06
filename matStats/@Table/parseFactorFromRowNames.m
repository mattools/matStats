function res = parseFactorFromRowNames(obj, pos1, len, factorName)
% Create a factor table by parsing row names.
%
%   FACT = parseFactorFromRowNames(THIS, POS1, LEN)
%   FACT = parseFactorFromRowNames(THIS, POS1, LEN, FACTORNAME)
%
%   Example
%     tab = Table.create(magic(4), 'RowNames', {'G1A', 'G1B', 'G2A', 'G2B'});
%     fact1 = parseFactorFromRowNames(tab, 2, 1, 'group');
%     fact2 = parseFactorFromRowNames(tab, 3, 1, 'type');
%     factors = [fact1 fact2]
%     factors = 
%                group    type
%     G1A            1       A
%     G1B            1       B
%     G2A            2       A
%     G2B            2       B
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
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
    'ColNames', {factorName}, ...
    'RowNames', obj.RowNames, ...
    'Levels', {levels}, ...
    'Name', obj.Name);
