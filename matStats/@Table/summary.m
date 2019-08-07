function summary(this)
%SUMMARY Display a summary of the data in the table
%
%   summary(TAB)
%   TAB.summary()
%   Display a short summary of the data table TAB. For each data column,
%   several statistics are computed and displayed. If the column is a
%   factor, the number of occurences of each factor level is given.
%
%   Example
%     % display summary of Iris data table
%     tab = Table.read('fisherIris.txt');
%     summary(tab)
%
%   See also
%     info, head
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-04-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% size of table
nRows = size(this.Data, 1);
nCols = size(this.Data, 2);

% number of text columns we can display
maxWidth = get(0, 'CommandWindowSize');
maxWidth = maxWidth(1);

% option to display empty lines or not
isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');

% name of descriptive statistics used for summary
statNames = {'Min', '1st Qu.', 'Median', 'Mean', '3rd Qu.', 'Max'};
nStats = length(statNames);

% number of rows used for display (7 stats).
nDisplayRows = nStats + 1;

if isLoose
    fprintf('\n');
end

if nRows > 0 && nCols > 0

    % padding between columns
    colPad = repmat(' ', nDisplayRows+1, 4);
    
    % initial text array
    txtArray = char(zeros(nDisplayRows + 1, 0));
    
    % iterate on columns
    for iCol = 1:nCols
        colName = this.ColNames{iCol};
        values  = this.Data(:, iCol);

        statCells = repmat({''}, nDisplayRows, 1);
             
        if ~isFactor(this, iCol)
             % data are numeric -> compute summary statistics
             [vmin, vmax, vmedian, vmean, vq1, vq3] = summaryStatistics(values);
             summaryStats = [...
                 vmin; ...
                 vq1; ...
                 vmedian; ...
                 vmean; ...
                 vq3; ...
                 vmax];
             
             % add number of missing values if there are some
             naNumber = sum(isnan(values));
             if naNumber > 0
                 statNames = [statNames , {'Missing'}]; %#ok<AGROW>
                 summaryStats = [summaryStats ; naNumber]; %#ok<AGROW>
             end
             
             % create formatting string
             fmt = createFormattingString(summaryStats);
             
             % create cell array for display
             for i = 1:length(summaryStats)
                 statCells{i} = sprintf(['%-9s' fmt], ...
                     [statNames{i} ':'], summaryStats(i));
             end
             
        else
            % data are factors -> display level count
            
            % number of levels
            nbLevels = length(this.Levels{iCol});
            
            % Count occurences number of each level
            h = zeros(nbLevels, 1);
            for i = 1:nbLevels
                h(i) = sum(values == i);
            end
            
            % number of characters of the lengthest level name
            nChar = max(cellfun(@length, this.Levels{iCol}));
            pattern = ['%-' num2str(nChar+1) 's %d'];
            
            % display the count of each factor level
            for i = 1:min(nbLevels, nDisplayRows)
                statCells{i} = sprintf(pattern, ...
                    [this.Levels{iCol}{i} ':'], h(i));
            end
            
            % eventually displays the number of other levels
            if nbLevels > nDisplayRows
                statCells{nDisplayRows} = sprintf('%d more: %d', ...
                    nbLevels-nDisplayRows+1, sum(h(nDisplayRows:end)));
            end
        end
        
        % convert the cell array to char array
        colText = char(statCells);
             
        % add the name of the colum
        colText = strjust(char(colName, colText));
        
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
            
            txtArray = char(zeros(nDisplayRows + 1, 0));
        end
        
        txtArray = [txtArray colPad colText]; %#ok<AGROW>
        
    end
    
else
    % one of the table dimension is empty -> do not display anything
    txtArray = sprintf('[empty %d-by-%d Table]', nRows, nCols);
    
end

disp(txtArray);

if (isLoose)
    fprintf('\n');
end


function [vmin, vmax, vmedian, vmean, vq1, vq3] = summaryStatistics(values)

% do no take into account NaN (missing values)
values = values(~isnan(values));

% sort, and compute order stats
n = length(values);
values = sort(values);
vmin = values(1);
vmax = values(end);

vmedian = mean([values(floor(n/2)) values(ceil(n/2))]);
vmean = mean(values);

vq1 = values( floor((n-1) * .25) + 1);
vq3 = values( floor((n-1) * .75) + 1);


function format = createFormattingString(values)

nDigitsMax = 6;

% compute number of digits before and after the decimal separator
nSigDigits = ceil(max(log10(abs(values))));
nDecDigits = max(nDigitsMax - nSigDigits - 1, 0);

% number of significant digits
nDigits = nSigDigits + nDecDigits;

% add one digit for the sign
signDigit = '';
if any(values < 0)
    nDigits = nDigits + 1;
    signDigit = ' ';
end

% add one digit for the decimal separator
if any((values - floor(values)) > 0)
    nDigits = nDigits + 1;
end

% create formatting string
format = sprintf('%%%s%d.%df', signDigit, nDigits, nDecDigits);
