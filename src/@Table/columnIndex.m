function indCol = columnIndex(this, colName)
%COLUMNINDEX Index of a column from its name
%
%   output = columnIndex(input)
%
%   Example
%   Tab2 = Tab';
%
%   See also
%   transpose
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

errorMsg = 'input table does not contain column named "%s"';

% check index of column
if isnumeric(colName)
    indCol = colName;
elseif ischar(colName)
    indCol = strmatch(colName, this.colNames, 'exact');
    if isempty(indCol)>0
        error(errorMsg, colName);
    end
elseif iscell(colName)
    N = length(colName);
    indCol = zeros(N, 1);
    names = this.colNames; 
    for i=1:N
        ind = strmatch(colName{i}, names, 'exact');
        if isempty(ind)
            error(errorMsg, colName{i});
        end
        indCol(i) = ind;
    end
else
    error('second argument should be a column name or a column index');
end
