function res = selectRows(obj, inds)
% Seelct a subset of the table based on row indices.
%
%   RES = selectRows(TAB, INDS)
%
%   Example
%     tab = Table.read('fisherIris');
%     tab2 = selectRows(tab, 1:5:150);
%     size(tab2)
%     ans =
%         30     5
%
%   See also
%     selectColumns
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-03-26,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.

newData = obj.Data(inds, :);
rowNames = {};
if ~isempty(obj.RowNames)
    rowNames = obj.RowNames(inds);
end

% transform data
res = Table(newData, 'RowNames', rowNames, 'Parent', obj);
