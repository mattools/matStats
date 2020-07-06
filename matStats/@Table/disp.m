function disp(obj)
% Display the content of a data table, with row and column names.
%
%   disp(TAB)
%
%   Example
%   disp
%
%   See also
%     display, show, head, tail
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% HISTORY
% 2014-06-25 add support for factors with level 0 (unassigned)


%% Initialisations

% loose format: display more empty lines
isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');

maxWidth = get(0, 'CommandWindowSize');
maxWidth = maxWidth(1);

% if isLoose
%     fprintf('\n');
% end

% get table size
nRows = rowNumber(obj);
nCols = columnNumber(obj);


% create a char array representing the table contents
if nRows > 0 && nCols > 0

    % padding between columns
    colPad = repmat(' ', nRows + 1, 4);
    
    % init row names
    if ~isempty(obj.RowNames)
        txtArray = strjust([colPad char([{' '}; obj.RowNames(:)])], 'left');
    else
        txtArray = char(zeros(nRows + 1, 0));
    end

    % iterate on columns
    for iCol = 1:nCols
        name = obj.ColNames{iCol};
        var  = obj.Data(:, iCol);
         
        % convert numeric data to character array
        colText = num2str(var);
        
        % add the name of the column
        if isempty(name)
            name = ' ';
        end
        colText = strjust(char(name, colText));
        
        
        % If obj new variable will extend the display past the right margin
        % width, display the output built up so far, and then restart for
        % display starting at the left margin.  Don't do that if obj is the
        % first variable, otherwise we'd display only the observation names.
        textWidth = size(txtArray, 2) + size(colPad, 2) + size(colText, 2);
        if iCol > 1 &&  textWidth > maxWidth
            disp(txtArray);
            fprintf('\n');
            if isLoose
                fprintf('\n');
            end
            
            if ~isempty(obj.RowNames)
                txtArray = strjust([colPad char([{' '}; obj.RowNames(:)])]);
            else
                txtArray = char(zeros(nRows + 1, 0));
            end
        end
        txtArray = [txtArray colPad colText]; %#ok<AGROW>

    end
    
else
    % In case of empty table, just display small info message
    txtArray = sprintf('    [empty %d-by-%d Table]', nRows, nCols);
    
end

disp(txtArray);

if isLoose
    fprintf('\n');
end

