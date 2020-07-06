function res = aggregate(obj, name, op, varargin)
% Group table rows according to unique values in a vector or column.
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
%   Uses one of the columns in the table as a basis for VALUES. In obj
%   case, the resulting table has one column left as the original table,
%   and rows are labeled using a composition of COLNAME and the unique
%   values in the column.
%
%
%   TAB2 = aggregate(..., 'rowNames', ROWNAMES)
%   Specifies the names of the rows in the new table.
%
%   Example
%     % Display mean values of each feature, grouped by Species
%     iris = Table.read('fisherIris');
%     aggregate(iris(:,1:4), iris('Species'), @mean)
%     ans = 
%                            SepalLength    SepalWidth    PetalLength    PetalWidth
%     Setosa-mean                  5.006         3.428          1.462         0.246
%     Versicolor-mean              5.936          2.77           4.26         1.326
%     Virginica-mean               6.588         2.974          5.552         2.026
%
%     % The same, but choose different row names
%     newNames = {'mean_of_Setosa', 'mean_of_Versicolor', 'mean_of_Virginica'};
%     aggregate(iris(:,1:4), iris('Species'), @mean, 'rowNames', newNames)
%     ans = 
%                               SepalLength    SepalWidth    PetalLength    PetalWidth
%     mean_of_Setosa                  5.006         3.428          1.462         0.246
%     mean_of_Versicolor              5.936          2.77           4.26         1.326
%     mean_of_Virginica               6.588         2.974          5.552         2.026
%
%
%   See also
%   groupStats
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2008-02-11,    using Matlab 7.4.0.287 (R2007a)
% Copyright 2008 INRA - BIA PV Nantes - MIAJ Jouy-en-Josas.


%% Process input arguments

% if operation is not specified, use 'mean' by default
if nargin < 3 || ~isa(op, 'function_handle')
    if nargin > 2
        varargin = [{op} varargin];
    end
    op = @mean;
end

useColName = false;

rowNames = {};
if nargin > 3 && iscell(varargin{1})
    rowNames = varargin{1};
    varargin{1} = [];
end

while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'rownames'
            rowNames = varargin{2};
        case 'usecolname'
            useColName = varargin{2};
        otherwise
            error(['Unknown parameter name: ' paramName]);
    end

    varargin(1:2) = [];
end


%% determine the name of each unique grouping value

% the name of each unique value
valueNames = {};

if isnumeric(name) && length(name) == rowNumber(obj)
    % Second argument is a list of values with same length as the number of
    % rows in the input table
    values  = name;
    cols    = 1:columnNumber(obj);
    colName = '';
    
elseif isa(name, 'Table')
    % Second argument is a table containing factor levels
%     [values truc] = indexGroupValues(name);
    values = name.Data(:, 1);
    colName = name.ColNames{1};
    cols    = 1:columnNumber(obj);
    
    if isFactor(name, 1)
        valueNames = name.Levels{1};
    end
    
else
    % Second argument is either column index or a column name
    % 1 extract group values
    % 2 remove group column from original table
    
    % find index of the column, keep only the first one
    ind = columnIndex(obj, name);
    ind = ind(1);
    
    % extract column to process
    values = obj.Data(:, ind);
    colName = obj.ColNames{ind};
    
    % indices of other columns
    cols = 1:columnNumber(obj);
    cols(ind) = [];
end


%% Performs grouping 

% number of selectedcolumns
nCols = length(cols);

% extract unique values
if ischar(values)
    uniVals = unique(values, 'rows');
    nValues = size(uniVals, 1);
else
    uniVals = unique(values);
    nValues = length(uniVals);
end

% create empty data array
res = zeros(length(uniVals), nCols);

% apply operation on each column
for i = 1:nValues
    inds = values == uniVals(i);
    for j = 1:nCols
        res(i, j) = feval(op, obj.Data(inds, cols(j)));
    end    
end

% if value names are not initialized, create string array of numeric vector 
if isempty(valueNames)
    if isnumeric(uniVals)
        valueNames = strtrim(cellstr(num2str(uniVals, '%d')));
    elseif ischar(uniVals)
        valueNames = strtrim(cellstr(uniVals));
    end
end

% extract names of rows, or create them if necessary
if isempty(rowNames)
    if useColName
        rowNames = strcat([colName '='], valueNames, ['-' char(op)]);
    else
        rowNames = strcat(valueNames, ['-' char(op)]);
    end
        
%     rowNames = strcat([colName '='], valueNames);
end

% create result dataTable
res = Table.create(res, 'ColNames', obj.ColNames(cols), 'RowNames', rowNames);

