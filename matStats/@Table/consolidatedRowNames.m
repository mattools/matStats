function rowNames = consolidatedRowNames(obj, varargin)
% Return a valid array of row names using the existing ones.
%
%   ROWNAMES = consolidatedRowNames(OBJ)
%   Returns a valid array of row names based on the "RowNames" property.
%   The result array has the following properties:
%   * size is NR-ny-1 cell array, where NR is the size of the Data property
%   * no empty cell
%   * contains all non-empty cells of the original RowNames property from
%       the OBJ class.
%
%   This function can be used to complete empty row names before display,
%   writing, or simply to update the table with valid row names.
%
%   Example
%      rowNames = consolidatedRowNames(tab);
%
%   See also
%     disp, write, createRowNames, consolidateRowNames
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2022-10-12,    using Matlab 9.13.0.2049777 (R2022b)
% Copyright 2022 INRAE.

% retrive data from Table object
rowNames = obj.RowNames;
nRows = size(obj.Data, 1);

if isempty(rowNames)
    % generate default names
    rowNames = createRowNames(obj, varargin{:});
else
    % check validity of input row names (take into account the case of
    % row names with incomplete names)
    inds = true(1, nRows);
    inds(1:length(rowNames)) = cellfun(@isempty, rowNames);
    if any(inds)
        defaultNames = createRowNames(obj, varargin{:});
        rowNames(inds) = defaultNames(inds);
    end
end
