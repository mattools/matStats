function info(obj)
% Display short summary of a data table.
%
%   info(TAB)
%   Display a short summary for the data table. Displays the name of each
%   column, its category (numerical or factor), and a range values.
%
%   Example
%     % display summary of Iris data table
%     tab = Table.read('fisherIris.txt');
%     info(tab)
%         Infos for table fisherIris:
%         [1] SepalLength: numerical  [ 4.3 ; 7.9 ]
%         [2] SepalWidth:  numerical  [ 2 ; 4.4 ]
%         [3] PetalLength: numerical  [ 1 ; 6.9 ]
%         [4] PetalWidth:  numerical  [ 0.1 ; 2.5 ]
%         [5] Species:     categorical with 3 levels { Setosa ; Versicolor ; Virginica}
%
%   See also
%     summary
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-05-15,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% print header
if ~isempty(obj.Name)
    disp(sprintf('Infos for table %s:', obj.Name)); %#ok<DSPS>
else
    disp('Info for data table:');
end

% number of columns
nCols = size(obj, 2);

% length of column names
colNames = obj.ColNames;
nameLengths = cellfun(@length, colNames);
maxLength = max(nameLengths);

% create a pattern for the name of current column
% Example of output: '[%2d] %-15s:'
nDigits = ceil(log10(nCols));
namePattern = sprintf('[%%%dd]%%-%ds:', nDigits, maxLength+1);

% iterate over the columns to display a summary line
for iCol = 1:nCols
    % create line header containing column index + name
    if ~isempty(colNames)
        colName = [' ' colNames{iCol}];
    else
        colName = '';
    end
    header = sprintf(namePattern, iCol, colName);
    
%     disp([colName ':']);
    isFact = isFactor(obj, iCol);
    if isFact
        pattern = [header ' categorical with %d levels'];
        colLevels = obj.Levels{iCol};
        str = sprintf(pattern, length(colLevels));
        
        % if few levels, append the names of the levels
        if length(colLevels) < 4
            str = [ str ' { ' colLevels{1} ]; %#ok<AGROW>
            for iLev = 2:length(colLevels)
                str = [str ' ; ' colLevels{iLev} ]; %#ok<AGROW>
            end
            str = [str  '}' ]; %#ok<AGROW>
        end
    else
        values = obj.Data(:, iCol);
        minVal = min(values);
        maxVal = max(values);
        pattern = [header ' numerical  [ %g ; %g ]'];
        str = sprintf(pattern, minVal, maxVal);
    end
    
    disp(str);
end
