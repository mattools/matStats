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

errorMsg = 'Input table does not contain column named "%s"';

% check index of column
if isnumeric(colName)
    % input argument is already an index
    indCol = colName;
    
elseif ischar(colName)
    % parse column name
    if strcmp(colName, ':')
        indCol = 1:length(this.colNames);
    else
        indCol = strmatch(colName, this.colNames, 'exact');
    end
    
    if isempty(indCol)>0
        error(errorMsg, colName);
    end
    
elseif iscell(colName)
    % parse a cell array of column names
    N = length(colName);
    indCol = zeros(N, 1);
    names = this.colNames; 
    for i = 1:N
        ind = strmatch(colName{i}, names, 'exact');
        if isempty(ind)
            error(errorMsg, colName{i});
        end
        indCol(i) = ind;
    end
    
else
    error('Second argument should be a column name or a column index');
end
