function b = isColumnName(this, colName)
%ISCOLUMNNAME Check if the table contains a column with the given name
%
%   B = isColumnName(TAB, COLNAME)
%   Returns TRUE if the table TAB contains a column whose name is COLNAME,
%   or if COLNAME is numeric.
%
%   Example
%   isColumnName
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check index of column
if isnumeric(colName)
    % input argument is already an index
    n = length(this.colNames);
    b = colName > 0 & colName <= n;
    
elseif ischar(colName)
    % parse column name
    n = size(colName, 1);
    b = false(n, 1);
    for i = 1:n
        b(i) = ~isempty(strmatch(colName(i,:), this.colNames, 'exact'));
    end
   
elseif iscell(colName)
    % parse a cell array of column names
    n = length(colName);
    b = false(n, 1);
    for i = 1:n
        b(i) = ~isempty(strmatch(colName{i}, this.colNames, 'exact'));
    end
    
else
    error('Second argument should be a column name or a column index');
end