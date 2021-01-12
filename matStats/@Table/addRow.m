function addRow(obj, varargin)
% Add a new row to the data table.
%
%   addRow(TAB, ROWDATA)
%   Adds the data given in ROWDATA to the data table
%
%   addRow(TAB, ROWNAME)
%   Adds a new empy row with the given name.
%
%   Example
%     iris = Table.read('fisherIris');
%     iris.addRow('last')
%
%   See also
%     addColumn, cat, vertcat

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% current data size
nRows = size(obj.Data, 1);
nCols = size(obj.Data, 2);

rowName = '';
rowData = [];

while ~isempty(varargin)
    var = varargin{1};
    if ischar(var)
        rowName = var;
    elseif isnumeric(var)
        rowData = var;
    else
        error('Could not add a row');
    end
    
    varargin(1) = [];
end


% check length of new data
if isempty(rowData)
    rowData = zeros(1, nCols);
elseif length(rowData) ~= nCols
    error('New row must have same number of columns than table');
end


% concatenate data
obj.Data = [obj.Data ; rowData];

if isempty(rowName)
    rowName = num2str(nRows + 1, '%d');
end
obj.RowNames = [obj.RowNames ; {rowName}];
    