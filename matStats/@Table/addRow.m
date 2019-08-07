function addRow(this, varargin)
%ADDROW Add a new row to the data table
%
%   addRow(TAB, ROWDATA)
%   Adds the data given in ROWDATA to the data table
%
%   addRow(TAB, ROWNAME)
%   Adds a new empy row with the given name.
%
%   Example
%     iris = Table.read('fisherIris');
%     iris.addRow('last')
%
%   See also
%     addColumn, cat, vertcat

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% current data size
nRows = size(this.data, 1);
nCols = size(this.data, 2);

rowName = '';
rowData = [];

while ~isempty(varargin)
    var = varargin{1};
    if ischar(var)
        rowName = var;
    elseif isnumeric(var)
        rowData = var;
    else
        error('Could not add a row');
    end
    
    varargin(1) = [];
end


% check length of new data
if isempty(rowData)
    rowData = zeros(1, nCols);
elseif length(rowData) ~= nCols
    error('New row must have same number of columns than table');
end


% % determine numerical data to add to the inner data
% if isnumeric(colData) || islogical(colData)
%     % column is numeric
%     numData = colData;
%     
% else
%     % column is a factor
%     if ischar(colData)
%         % Factor are given as a char array
%         [levels pos indices] = unique(strtrim(colData), 'rows');
%         [pos2 inds] = sort(pos); %#ok<ASGLU>
%         
%         % transform unique strings to cell array of factor levels
%         levels = strtrim(cellstr(levels(inds,:)));
%         this.levels{nCols + 1} = levels;
%         
%         % compute corresponding numeric data (level indices)
%         numData = zeros(size(indices));
%         for i = 1:length(pos)
%             numData(indices == inds(i)) = i;
%         end
%         
%     elseif iscell(colData)
%         % Factor are given as a cell array
%         [levels pos indices] = unique(strtrim(colData));  %#ok<ASGLU>
%         numData = indices;
%         this.levels{nCols + 1} = levels;
%         
%     else
%         error(['Column factor have an unknown type: ' class(colData)]);
%     end
% end
 
% concatenate data
this.Data = [this.Data ; rowData];

if isempty(rowName)
    rowName = num2str(nRows + 1, '%d');
end
this.RowNames = [this.RowNames ; {rowName}];
    