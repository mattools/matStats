function res = reorderLevels(this, newOrder)
%REORDERLEVELS Change the order the levels are stored
%
%   TAB2 = reorderLevels(TAB, NEWORDER)
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     species = tab('Species');
%     sp2 = reorderLevels(species, [3 2 1]);
%     species.levels{1}
%     sp2.levels{1}
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-04-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% Check validity of table
if size(this, 2) ~= 1
    error('Requires a single column table');
end
if ~isFactor(this, 1)
    error('Requires a table with factor column');
end

% check correspondence of tables
nLevels = length(this.levels{1});
if length(newOrder) ~= nLevels
    error('Length of new indices does not match the number of levels');
end

% compute the vector of new indices
data = zeros(size(this.data));
for i = 1:length(newOrder)
    data(this.data == newOrder(i)) = i;
end

% reorder the levels
levels = {this.levels{1}(newOrder)};

% create result data table
res = Table(data, this.colNames, this.rowNames, ...
    'levels', levels);
