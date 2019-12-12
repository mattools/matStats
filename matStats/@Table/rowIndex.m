function indRow = rowIndex(obj, rowName)
% Index of a row from its name.
%
%   IND = rowIndex(TABLE, ROWNAME)
%
%   Example
%   rowIndex
%
%   See also
%     columnIndex
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

errorMsg = 'Input table does not contain row named "%s"';

% check index of row
if isnumeric(rowName)
    % argument is already a row index
    indRow = rowName;
    
elseif ischar(rowName)
    % parse row name
    if strcmp(rowName, ':')
        indRow = 1:length(obj.RowNames);
    else
        indRow = find(strcmp(rowName, obj.RowNames'));
    end
    
    if isempty(indRow)>0
        error(errorMsg, rowName);
    end
    
elseif iscell(rowName)
    % parse a cell array of row names
    N = length(rowName);
    indRow = zeros(N, 1);
    names = obj.RowNames;
    for i = 1:N
        ind = find(strcmp(rowName{i}, names));
        if isempty(ind)
            error(errorMsg, rowName{i});
        end
        indRow(i) = ind;
    end
    
else
    error('Second argument should be a row name or a row index');
end

