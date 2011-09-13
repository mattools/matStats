function disp(this)
%DISP Display the content of a data table, with row and column names
%
%   output = disp(input)
%
%   Example
%   disp
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% loose format: display more empty lines
isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');

% isLong = ~isempty(strfind(get(0,'Format'),'long'));
% dblDigits = 5 + 10*isLong; % 5 or 15
% snglDigits = 5 + 2*isLong; % 5 or 7
maxWidth = get(0, 'CommandWindowSize');
maxWidth = maxWidth(1);

if isLoose
    fprintf('\n');
end

% get table size
nRows = rowNumber(this);
nCols = columnNumber(this);

if nRows > 0 && nCols > 0

    % padding between columns
    colPad = repmat(' ', nRows+1, 4);
    
    % init row names
    if ~isempty(this.rowNames)
        txtArray = strjust([colPad char([{' '}; this.rowNames(:)])]);
    else
        txtArray = char(zeros(nRows + 1, 0));
    end

    % iterate on columns
    for iCol = 1:nCols
        name = this.colNames{iCol};
        var  = this.data(:, iCol);
         
        if ~this.isFactor(iCol)
            % data are numeric -> convert to character array
            colText = num2str(var);
                    
        else
            colLevels = this.levels{iCol};
            if iscell(colLevels)
                colText = strjust(char(colLevels(var)));
            else
                colText = strjust(colLevels(var, :));
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

        % add the name of the colum
        colText = strjust(strvcat(name, colText)); %#ok<VCAT>
        
        
        % If this new variable will extend the display past the right margin
        % width, display the output built up so far, and then restart for
        % display starting at the left margin.  Don't do that if this is the
        % first variable, otherwise we'd display only the observation names.
        textWidth = size(txtArray, 2) + size(colPad, 2) + size(colText, 2);
        if iCol > 1 &&  textWidth > maxWidth
            disp(txtArray);
            fprintf('\n');
            if isLoose
                fprintf('\n');
            end
            
            if isempty(this.rowNames)
                txtArray = char(zeros(nRows+1, 0));
            else
                txtArray = strjust([colPad char([{' '}; this.rowNames])]);
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

