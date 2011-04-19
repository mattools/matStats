function varargout = summary(this)
%SUMMARY Display a summary of the data in the table
%
%   TAB.summary()
%   summary(TAB)
%   Display a short summary of the data table TAB. For each data column,
%   several statistics are computed and displayed. If the column is a
%   factor, the number of occurences of each factor level is given.
%
%   C = TAB.summary();
%   Return the result in a cell array. The array C has as many columns as
%   the number of columns in the data table.
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-04-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% size of table
nCols = size(this.data, 2);

% allocate memory
nDisplayRows = 4;
data = cell(nDisplayRows+1, nCols);

% format each column of data table
for i = 1:nCols
    col = this.data(:, i);
    
    if isempty(this.levels{i})
        % process numeric column
        data(2, i) = {num2str(min(col),     'Min:    %f')};
        data(3, i) = {num2str(median(col),  'Median: %f')};
        data(4, i) = {num2str(mean(col),    'Mean:   %f')};
        data(5, i) = {num2str(max(col),     'Max:    %f')};
        
    else
        % process level column
        
        % extract unique values
        [B, I, J] = unique(col); %#ok<ASGLU>
        
        % compute occurences of each unique value
        h = hist(J, 1:max(J))';
        
        % number of characters of the lengthest level name
        nChar = max(cellfun(@length, this.levels{i}));
        pattern = ['%-' num2str(nChar+1) 's %d'];
        
        % write a string for each factor level
        for j = 1:length(this.levels{i})
            data{j+1, i} = sprintf(pattern, [this.levels{i}{j} ':'], h(j));
        end
    end    
end

% add column names, right-aligned
nChar = max(cellfun(@length, data(2:end, :)), [], 1);
for i = 1:nCols
    pattern = ['%' num2str(nChar(i)) 's'];
    data{1, i} = sprintf(pattern, this.colNames{i});
end

% if an argument is asked, return the resulting cell array
if nargout > 0
    varargout = {data};
else
    disp(data);
end
