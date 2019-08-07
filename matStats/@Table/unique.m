function [res, I, J] = unique(this, varargin)
%UNIQUE Returns unique values in data tables
%
%   UN = unique(TAB)
%   Returns unique values in data table TAB.
%   If table is numeric (all columns contains numeric values), returns
%   unique data values.
%   If table contains only factor/grouping columns, returns a new table
%   containing the set of unique combinations of factor levels.
%
%
%   Example
%     iris = Table.read('fisherIris');
%     unique(iris('Species'))
%     ans = 
%                                  Species
%             Species=Setosa        Setosa
%         Species=Versicolor    Versicolor
%          Species=Virginica     Virginica
% 
%
%   See also
%     find
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-01-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% in case of table with no factor column, simply returns the unique data
% values.
if ~hasFactors(this)
    [res, I, J] = unique(this.Data, varargin{:});
    return;
end

% all columns should be factor
nCols = size(this, 2);
if sum(~isFactor(this, 1:nCols)) > 0
    error('Requires either none or all columns to be factors');
end

% for creating new names
format = '%s=%s';

% compute unique group of factors
[res, I, J] = unique(this.Data, 'rows');
nRows = size(res, 1);

% allocate memory
rowNames = cell(nRows, 1);
strings = cell(1, nCols);

% compute the name of each row
for iRow = 1:nRows
    
    % iterate over columns for formatting labels
    for iCol = 1:size(this, 2)
        
        % get level for each column as string
        levels = this.Levels{iCol};
        level = levels{res(iRow, iCol)};
        if isnumeric(level)
            level = num2str(level);
        end
        
        % concatenate col name and level name
        label = sprintf(format, this.ColNames{iCol}, level);
        strings{iCol} = label;
    end
    
    % concatenate all labels to create new row name
    label = strings{1};
    for i = 2:length(strings)
        label = [label ' * ' strings{i}]; %#ok<AGROW>
    end
    rowNames{iRow} = label;
end

% create the new result table
res = Table(res, this.ColNames, rowNames);
res.Levels = this.Levels;
