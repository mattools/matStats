function summary(this)
%SUMMARY Display a summary of the data in the table
%
%   summary(TAB)
%   TAB.summary()
%   Display a short summary of the data table TAB. For each data column,
%   several statistics are computed and displayed. If the column is a
%   factor, the number of occurences of each factor level is given.
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-04-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% size of table
nRows = size(this.data, 1);
nCols = size(this.data, 2);

% number of text columns we can display
maxWidth = get(0, 'CommandWindowSize');
maxWidth = maxWidth(1);

% option to display empty lines or not
isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');

% name of descriptive statistics used for summary
statNames = {'Min', '1st Qu.', 'Median', 'Mean', '3rd Qu.', 'Max'};
nStats = length(statNames);

% number of rows used for display (4 stats, 3 are kept for later use).
nDisplayRows = 7;

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
        colName = this.colNames{iCol};
        values  = this.data(:, iCol);

        statCells = repmat({''}, nDisplayRows, 1);

        if ~this.isFactor(iCol)
             % data are numeric -> compute summary statistics
             [vmin vmax vmedian vq1 vq3] = computeOrderStats(values);
             summaryStats = [...
                 vmin; ...
                 vq1; ...
                 vmedian; ...
                 mean(values); ...
                 vq3; ...
                 vmax];
             
             % comptue formatting string of numeric values
             nDigits = 6;
             nSigDigits = ceil(max(log10(abs(summaryStats))));
             nDecDigits = max(nDigits - nSigDigits - 1, 0);
             fmt = sprintf('%%%d.%df', nSigDigits+1, nDecDigits);
             
             % create cell array for display
             for i = 1:nStats
                 statCells{i} = sprintf(['%-9s' fmt], ...
                     [statNames{i} ':'], summaryStats(i));
             end
             
        else
            % data are factors -> display level count
            
            % first extract unique values
            [B, I, J] = unique(values); %#ok<ASGLU>
            
            % compute occurences of each unique value
            h = hist(J, 1:max(J))';
            
            % number of characters of the lengthest level name
            nChar = max(cellfun(@length, this.levels{iCol}));
            pattern = ['%-' num2str(nChar+1) 's %d'];
            
            % display the count of each factor level
            nbLevels = length(this.levels{iCol});
            for i = 1:min(nbLevels, nDisplayRows)
                statCells{i} = sprintf(pattern, ...
                    [this.levels{iCol}{i} ':'], h(i));
            end
            
            % eventually displays the number of levels
            if nbLevels > nDisplayRows
                statCells{nDisplayRows} = sprintf('%d more: %d', ...
                    nbLevels-nDisplayRows+1, sum(h(nDisplayRows:end)));
            end
        end
        
        % convert the cell array to char array
        colText = char(statCells);
             
        % add the name of the colum
        colText = strjust(strvcat(colName, colText)); %#ok<VCAT>
        
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


function [vmin vmax vmedian vq1 vq3] = computeOrderStats(values)

n = length(values);
values = sort(values);
vmin = values(1);
vmax = values(end);

vmedian = mean([values(floor(n/2)) values(ceil(n/2))]);

vq1 = values( floor((n-1) * .25) + 1);
vq3 = values( floor((n-1) * .75) + 1);
