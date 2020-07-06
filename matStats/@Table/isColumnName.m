function b = isColumnName(obj, colName)
%Check if the table contains a column with the given name.
%
%   B = isColumnName(TAB, COLNAME)
%   Returns TRUE if the table TAB contains a column whose name is COLNAME,
%   or if COLNAME is numeric.
%
%   Example
%     tab = Table.read('fisherIris');
%     isColumnName(tab, 'Species')
%     ans =
%       logical
%        1
%
%   See also
%     columnIndex
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check index of column
if isnumeric(colName)
    % input argument is already an index
    n = length(obj.ColNames);
    b = colName > 0 & colName <= n;
    
elseif ischar(colName)
    % parse column name
    n = size(colName, 1);
    b = false(n, 1);
    for i = 1:n
        b(i) = ~isempty(find(strcmp(colName(i,:), obj.ColNames), 1));
    end
   
elseif iscell(colName)
    % parse a cell array of column names
    n = length(colName);
    b = false(n, 1);
    for i = 1:n
        b(i) = ~isempty(find(strcmp(colName{i}, obj.ColNames), 1));
    end
    
else
    error('Second argument should be a column name or a column index');
end