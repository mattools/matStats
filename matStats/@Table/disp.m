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
% e-mail: david.legland@inrae.fr
% Created: 2011-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% HISTORY
% 2014-06-25 add support for factors with level 0 (unassigned)


%% Initialisations

% loose format: display more empty lines
isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');

% isLong = ~isempty(strfind(get(0,'Format'),'long'));
% dblDigits = 5 + 10*isLong; % 5 or 15
% snglDigits = 5 + 2*isLong; % 5 or 7
maxWidth = get(0, 'CommandWindowSize');
maxWidth = maxWidth(1);

% if isLoose
%     fprintf('\n');
% end

% get table size
nRows = rowNumber(obj);
nCols = columnNumber(obj);

% In case of empty table, just display small info message
if nRows == 0 || nCols == 0
    fprintf('    [empty %d-by-%d Table]\n', nRows, nCols);
    if isLoose
        fprintf('\n');
    end
    return;
end


%% Create text array
% create a char array 'txtArray' representing the table contents
    
% the number of text rows of text array
% (nRows + header + header line)
nRows2 = nRows + 2;

% padding between columns
colPad = repmat(' ', nRows2, 4);

% init row names
if ~isempty(obj.RowNames)
    txtArray = strjust([colPad char([{' '}; {' '}; obj.RowNames(:)])], 'left');
else
    txtArray = char(zeros(nRows2, 0));
end

% iterate on columns to append text
for iCol = 1:nCols
    name = obj.ColNames{iCol};
    var  = obj.Data(:, iCol);
    
    if ~isFactor(obj, iCol)
        % data are numeric -> convert to character array
        colText = num2str(var);
        
    else
        % data are factors -> identify level names
        % Get levels of current factor, and add an 'Unknown' level name
        % in case of index 0
        colLevels = obj.Levels{iCol};
        if iscell(colLevels)
            % factor levels given as cell array of strings
            colLevels2 = [{'N.A.'} ; colLevels(:)];
            colText = strjust(char(colLevels2(var + 1)));
        else
            % factor levels given as char array
            colLevels2 = char('N.A.', colLevels);
            colText = strjust(colLevels2(var + 1, :));
        end
        
        % replace factor levels that are too long by a short description
        if size(colText, 2) > 12
            lens = cellfun(@length, strtrim(cellstr(colText)));
            inds = find(lens > 10);
            for i = 1:length(inds)
                str = sprintf('[1x%d char]', lens(inds(i)));
                colText(inds(i), :) = ' ';
                colText(inds(i), 1:length(str)) = str;
            end
        end
    end
    
    % add the name of the column
    if isempty(name)
        name = ' ';
    end
    colLine = repmat('-', 1, length(name));
    colText = strjust(char(name, colLine, colText));
    
    
    % If this new column will extend the display past the right margin
    % width, display the output built up so far, and then restart for
    % display starting at the left margin.  
    % Don't do that if this is the first variable, otherwise we would
    % display only the observation names. 
    textWidth = size(txtArray, 2) + size(colPad, 2) + size(colText, 2);
    if textWidth > maxWidth && iCol > 1
        % display text
        disp(txtArray);
        
        % new line
        fprintf('\n');
        if isLoose
            fprintf('\n');
        end
        
        % reinitialize text array for processing next column(s)
        if ~isempty(obj.RowNames)
            txtArray = strjust([colPad char([{' '}; {' '}; obj.RowNames(:)])]);
        else
            txtArray = char(zeros(nRows2, 0));
        end
    end
    txtArray = [txtArray colPad colText]; %#ok<AGROW>
    
end


%% Display text array

disp(txtArray);

if isLoose
    fprintf('\n');
end

