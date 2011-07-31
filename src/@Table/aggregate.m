function res = aggregate(this, name, op, varargin)
%AGGREGATE Group table rows according to unique values in a vector or column
%
%   TAB2 = aggregate(TAB, VALUES, OP)
%   VALUES is a column vector with as many elements as the number of rows
%   in the table, and OP is a mathematical operation which computes a value
%   from an array, like 'min', 'max', 'mean'...
%
%   For each unique value in VALUES, the function selects row indices such
%   that values(i)==value, and applies the operation OP to each column of
%   the selected rows. This results is a new row for each unique value in
%   VALUES.
%
%   The resulting table has as many columns as the original table, and a
%   number of rows equal to the number of unique values in VALUES. Rows are
%   labeled with the unique values in VALUES.
%   
%   TAB2 = aggregate(TAB, COLNAME, OP)
%   TAB2 = aggregate(TAB, COLINDEX, OP)
%   Uses one of the columns in the table as a basis for VALUES. In this
%   case, the resulting table has one column left as the original table,
%   and rows are labeled using a composition of COLNAME and the unique
%   values in the column.
%
%
%   TAB2 = aggregate(..., ROWNAMES)
%   Specifies the names of the rows in the new table.
%
%   Example
%   aggregate
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2008-02-11,    using Matlab 7.4.0.287 (R2007a)
% Copyright 2008 INRA - BIA PV Nantes - MIAJ Jouy-en-Josas.


%% Process input arguments

if isnumeric(name) && length(name) == rowNumber(this)
    % Second argument is a list of values with same length as the number of
    % rows in the input table
    values  = name;
    cols    = 1:columnNumber(this);
    colName = '';
    
else
    % Second argument is either column index or a column name
    
    % find index of the column, keep only the first one
    ind = this.columnIndex(name);
    ind = ind(1);
    
    % extract column to process
    values = this.data(:, ind);
    colName = this.colNames{ind};
    
    % indices of other columns
    cols = 1:columnNumber(this);
    cols(ind) = [];
end


%% Performs grouping 

% number of selectedcolumns
nCols = length(cols);

% extract unique values
uniVals = unique(values);

% create empty data array
res = zeros(length(uniVals), nCols);

% apply operation on each column
for i = 1:length(uniVals)
    inds = values == uniVals(i);
    for j = 1:nCols
        res(i, j) = feval(op, this.data(inds, cols(j)));
    end    
end

% extract names of rows, or create them if necessary
if ~isempty(varargin)
    rowNames = varargin{1};
else
    rowNames = strtrim(cellstr(num2str(uniVals, [colName '%d'])));
end

% create result dataTable
res = Table(res, 'colNames', this.colNames(cols), 'rowNames', rowNames);

