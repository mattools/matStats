function info(this)
%INFO Display short summary of a data table
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
%         SepalLength: numerical  [ 4.3 ; 7.9 ]
%         SepalWidth:  numerical  [ 2 ; 4.4 ]
%         PetalLength: numerical  [ 1 ; 6.9 ]
%         PetalWidth:  numerical  [ 0.1 ; 2.5 ]
%         Species:     categorical with 3 levels { Setosa ; Versicolor ; Virginica}
%
%   See also
%     summary
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-05-15,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

if ~isempty(this.name)
    disp(sprintf('Infos for table %s:', this.name)); %#ok<DSPS>
else
    disp('Info for data table:');
end

nameLengths = cellfun(@length, this.colNames);
maxLength = max(nameLengths);
namePattern = sprintf('%%-%ds', maxLength+1);


for iCol = 1:length(this.colNames)
    colName = this.colNames{iCol};
    
%     disp([colName ':']);
    isFact = isFactor(this, iCol);
    if isFact
        pattern = [namePattern ' categorical with %d levels'];
        colLevels = this.levels{iCol};
        str = sprintf(pattern, [colName ':'], length(colLevels));
        
        % if few levels, append the names of the levels
        if length(colLevels) < 4
            str = [ str ' { ' colLevels{1} ]; %#ok<AGROW>
            for iLev = 2:length(colLevels)
                str = [str ' ; ' colLevels{iLev} ]; %#ok<AGROW>
            end
            str = [str  '}' ]; %#ok<AGROW>
        end
    else
        values = this.data(:, iCol);
        minVal = min(values);
        maxVal = max(values);
        pattern = [namePattern ' numerical  [ %g ; %g ]'];
        str = sprintf(pattern, [colName ':'], minVal, maxVal);
    end
    
    disp(str);
end
