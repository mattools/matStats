function res = selectColumns(obj, inds)
% Seelct a subset of the table based on columns indices.
%
%   RES = selectColumns(TAB, INDS)
%
%   Example
%     tab = Table.read('fisherIris');
%     tab2 = selectColumns(tab, 1:4);
%     size(tab2)
%     ans =
%        150     4
%
%
%   See also
%     selectRows
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-03-26,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.

newData = obj.Data(:, inds);
colNames = {};
if ~isempty(obj.ColNames)
    colNames = obj.ColNames(inds);
end

% transform data
res = Table(newData, 'ColNames', colNames, 'Parent', obj);
