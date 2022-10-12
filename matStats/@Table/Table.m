classdef (InferiorClasses = {?matlab.graphics.axis.Axes}) Table < handle
% Class for data table with named rows and columns.
%
%   Creation:
%   tab = Table(DATA);
%   tab = Table(DATA, 'RowNames', ROWNAMES, 'ColNames', COLNAMES);
%   Create data table from a numeric array, with possibility to specify
%   values of some parameters. See Table/Table.
%
%   tab = Table.read(FILENAME);
%   Read the content of a data table from a text file.
%
%   Display info:
%   tab.plot(COLNAME);
%   tab.scatter(COLUMN1, COLUMN2);
%
%   Table creation
%   Table                   - Class for data table with named rows and columns
%   create                  - Create a new data table
%
%   Table display and information
%   info                    - Display short summary of a data table.
%   summary                 - Display a summary of the data in the table.
%   disp                    - Display the content of a data table, with row and column names.
%   show                    - Display the content of the table in a new figure.
%   head                    - Show the first rows of a data table.
%   tail                    - Show the last rows of a data table.
%
%   Basic statistical analyses
%   stats                   - Compute basic descriptive statistics on data table columns
%   aggregate               - Group table rows according to unique values in a vector or column
%   corrcoef                - Correlation coefficients of table data
%   cov                     - Covariance matrix of the data table
%   zscore                  - Standardized z-score
%   geomean                 - Compute geometrical mean of table columns
%   ttest2                  - Two-sample t-test
%
%   Plot and display
%   plot                    - Plot the content of a column.
%   linePlot                - Plot the content of a column as continuous lines.
%   barPlot                 - Bar plot of the table data.
%   stairStepsPlot          - Plot the content of a column as stairs.
%   stemPlot                - Plot the content of a column as stems.
%   errorbar                - Overload the errorbar function to manage data tables
%   histogram               - Histogram plot of a column in a data table
%   scatter                 - Scatter plot of table data
%   scatterNames            - Scatter names according to two variables
%   surf                    - Surfacic representation of the data stored in a Table
%   hist                    - Histogram plot of a column in a data table
%   boxplot                 - Box plot of a data table
%   violinPlot              - Plot distribution of data in a table
%   barweb                  - Bar plot of the table data with error bars ("WEB")
%   plotmatrix              - Overload plotmatrix function to display column names
%   scatterLabels           - Scatter labels according to 2 variables
%   scatterPlot             - Scatter plot of two columns in a table
%   correlationCircles      - Represent correlation matrix using colored circles
%   plotRows                - Plot all the rows of the data table
%
%   Factors Managment
%   setAsFactor             - Set the given column as a factor
%   isFactor                - Check if a column is treated as a factor
%   hasFactors              - Check if the table has column(s) representing factor(s)
%   clearFactors            - Replace all factor columns by numeric columns
%   factorLevels            - List of the levels for a given factor
%   setFactorLevels         - Set up the levels of a factor in a table
%   getLevel                - Returns the factor level for specified row and column
%   trimLevels              - Recompute level indices to keep only existing values
%   reorderLevels           - Change the order the levels are stored
%   combineFactors          - Aggregate two factors to create a new factor
%   mergeFactorLevels       - Merge several levels of a factor
%   parseFactorFromRowNames - Create a factor table by parsing row names
%   strcmp                  - Compare factor levels with a string
%   groupfun                - Aggregate table values according to levels of a group
%   groupStats              - Compute basic statistics for each level of a group
%   paragons                - Find paragon for each level of a group
%
%   Display groups
%   kmeans                  - K-means clustering of the data table
%   scatterGroup            - Scatter plot individuals grouped by classes
%   scatterGroup3d          - Scatter plot individuals grouped by classes
%   plotGroups              - Display data ordererd by their group levels
%   plotGroupMeans          - One-line description here, please.
%   plotGroupRows           - Plot data table rows with different style by group
%   plotGroupErrorBars      - One-line description here, please.
%   Basic functions
%   columnIndex             - Index of a column from its name
%   isColumnName            - Check if the table contains a column with the given name
%   columnNumber            - Number of columns in the table
%   getColumn               - Extract column data of the table
%   rowIndex                - Index of a row from its name
%   rowNumber               - Number of rows in the table
%   getRow                  - Extract row data of the table
%
%   File I/O
%   read                    - Read a datatable file
%   write                   - Write a datatable into a file
%
%   Utility functions
%   getValue                - Returns the value for the given row and column.
%   addColumn               - Add a new column to the data table.
%   addRow                  - Add a new row to the data table.
%   apply                   - Apply the given function to each element of the table.
%   findClosestPoint        - Find the index of the row with closest coordinates.
%   unique                  - Returns unique values in data tables.
%   bsxfun                  - Binary Singleton Expansion Function for Tables.
%   bsxfun                  - Binary Singleton Expansion Function for Tables.
%   concatFiles             - Concatenate a list of files containing tables into new a file.
%   printLatex              - Print content of a table as a latex tabular.
%   numel                   - Overload default behaviour for the numel function.
%
%   Array manipulation
%   size                    - Size of a data table
%   length                  - Number of rows in the table.
%   horzcat                 - Concatenate tables horizontally
%   vertcat                 - Concatenate tables vertically
%   reshape                 - Reshape a data table
%   interleave              - Interleave the rows of two data tables
%   transpose               - Transpose a data table and intervert names of row and columns
%   ctranspose              - Simple wrapper to transpose function to comply with ' syntax
%   end                     - Determine last index when accessing a table
%   subsasgn                - Overrides subsasgn function for Image objects
%   subsref                 - Overrides subsref function for Table objects
%   subsindex               - Overload the subsindex method for Table objects
%   repmat                  - Replicate and tile a data table
%   sortrows                - Sort entries of data table according to row names
%   flatten                 - Transform the data table into a single column table
%   cellstr                 - Convert data table into cell array of strings
%   equals                  - Checks if two Table objects are the same
%
%   Maths and elementary functions
%   abs                     - Absolute value of data in table
%   round                   - Round values in the table
%   ceil                    - Ceil values in the table
%   floor                   - Floor values in the table
%   exp                     - Exponential of table values
%   log                     - Logarithm of table values
%   log10                   - Decimal logarithm of table values
%   log2                    - Binary logarithm of table values
%   max                     - Put the max of each column in a new table
%   mean                    - Compute the mean of table columns
%   median                  - Put the median of each column in a new table
%   min                     - Put the min of each column in a new table
%   minus                   - Overload the minus operator for Table objects
%   mpower                  - Overload the mpower operator for Table objects
%   mrdivide                - Overload the mrdivide operator for Table objects
%   mtimes                  - Overload the mtimes operator for Table objects
%   nthroot                 - N-th root of table values
%   plus                    - Overload the plus operator for Table objects
%   power                   - Overload the power operator for Table objects
%   rdivide                 - Overload the rdivide operator for Table objects
%   sqrt                    - Square root of table values
%   std                     - Put the std of each column in a new table
%   uminus                  - Overload the uminus operator for Table objects
%   uplus                   - Overload the uplus operator for Table objects
%   var                     - Put the variance of each column in a new table
%   sum                     - Put the sum of each column in a new table
%   times                   - Overload the times operator for Table objects
%
%   Binary functions
%   ge                      - Overload the ge operator for Table objects
%   eq                      - Overload the eq operator for Table objects
%   gt                      - Overload the gt operator for Table objects
%   lt                      - Overload the lt operator for Table objects
%   le                      - Overload the le operator for Table objects
%   ne                      - Overload the ne operator for Table objects
%   and                     - Overload the and operator for Table objects
%   or                      - Overload the or operator for Table objects
%   not                     - Invert logical values of table
%   xor                     - Overload the xor operator for Table objects
%   ismember                - Override the ismember function
%   find                    - Find non zero elements in the table
%   logical                 - Convert to logical array
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of static methods
methods (Static)
    tab = create(varargin)
    tab = read(fileName, varargin)
    varargout = concatFiles(inputFiles, outputFile, varargin)
end


%% Declaration of class properties
properties
    % Inner data of the table, stored in a Nr-by-Nc array of double.
    Data;
    
    % Name of columns, stored in a 1-by-Nc cell array of strings.
    ColNames;
    
    % Name of rows, stored in a Nr-by-1 cell array of strings.
    % Can be empty.
    RowNames;

    % The name of the table.
    Name;
    
    % The name of the file used for initializing the Table.
    FileName;
    
    % Factor levels, stored in a 1-by-Nc cell array. Each cell can be one
    % of the following:
    % * empty (column is not a factor), 
    % * a cell array of chars (column is a categorical factor), 
    % * an array of numeric values (colum is an ordered factor).
    % For columns considered as factor, the corresponding column in the
    % data array should only contain integer, whose maximum value should
    % not exceed the number of elements in the level cell.
    Levels;
    
    % The preferred plot type of each column. Should have as many elements
    % as the number of columns. Elements must be one of: {'line', 'stem',
    % 'stairStep', 'bar'}. Default is 'line'.
    PreferredPlotTypes;
end


%% Private methods declaration
methods (Access = private)
    rowNames = consolidatedRowNames(obj, varargin);
end


%% Constructor
methods
    function obj = Table(varargin)
    % Constructor for Table class
    %
    %   TAB = Table(DATA)
    %   where DATA is a numeric array, create a new data table from a
    %   numeric array.
    %
    %   TAB = Table(..., 'ColNames', NAMES)
    %   Also specifies the name of columns. NAMES is a cell array with as
    %   many columns as the number of columns of the data table. 
    %
    %   TAB = Table(..., 'RowNames', NAMES)
    %   Also specifies the name of rows. NAMES is a cell array with as many
    %   rows as the number of rows of the data table. 
    %
    %   TAB = Table(..., 'Name', NAME)
    %   Also specify the name of the data table. NAME is a char array.
    %  
    %   See Also
    %     Table/create
    %

        % special case of empty constructor
        if nargin == 0
            % empty constructor
            obj.Data = [];
            obj.RowNames = {};
            obj.ColNames = {};
            obj.Name = '';
            obj.Levels = {};
            obj.PreferredPlotTypes = {};
            return;
        end
        
        
        % ---------
        % Extract the data of the table
        
        var1 = varargin{1};
        if isa(var1, 'Table')
            % copy constructor
            tab = var1;
            obj.Data = tab.Data;
            obj.RowNames   = tab.RowNames;
            obj.ColNames   = tab.ColNames;
            obj.Name       = tab.Name;
            obj.Levels     = tab.Levels;
            obj.PreferredPlotTypes = tab.PreferredPlotTypes;
            
            varargin(1) = [];
            
        elseif (isnumeric(var1) || islogical(var1) || iscell(var1)) && size(var1, 2) == 1 && size(var1, 1) > 1
            % Each column is specified as a single column, with either
            % numeric or cell type
            
            % number of rows
            nRows = size(var1, 1);
            
            % determine the number of columns, by keeping all input args
            % with same size as first input arg.
            nCols = 1;
            for i = 2:length(varargin) 
                var = varargin{i};
                if (~ischar(var) && size(var, 2) ~= 1) || size(var, 1) ~= nRows
                    break;
                end
                nCols = nCols + 1;
            end
            
            % format data table
            obj.Data = zeros(nRows, nCols);
            obj.Levels = cell(1, nCols);
            
            % fill up each column
            for iCol = 1:nCols
                % current column
                % assume a numeric, char, or cell array as column vector
                col = varargin{iCol};
                
                if isnumeric(col) || islogical(col)
                    % all data are numeric
                    obj.Data(:, iCol)  = col;
                else
                    % convert char arrays to cell arrays
                    if ischar(col)
                        col = strtrim(cellstr(col));
                    end
                    
                    % character or cell array are used as factors
                    [levels, I, num]  = unique(col); %#ok<ASGLU>
                    obj.Data(:, iCol)  = num;
                    obj.Levels{iCol}   = levels;
                end
            end
            
            % remove processed input args.
            varargin(1:nCols) = [];
            
            % default column names
            obj.ColNames = strtrim(cellstr(num2str((1:nCols)')))';
            
            % populates the column names from input arguments
            for iCol = 1:nCols
                name = inputname(iCol);
                if ~isempty(name)
                    obj.ColNames{iCol} = name;
                end
            end
            
        elseif isnumeric(var1) || islogical(var1)
            % If first argument is numeric, assume obj is data array
            obj.Data = var1;
            varargin(1) = [];
            
        elseif iscell(var1)
            % create table from cell array.
            % The cell array can be either:
            % * a N-by-P cell array of N rows and P columns,
            % * a cell array of columns, each column being stored as an
            %   array.
            
            % extract data
            cellArray = var1;
            varargin(1) = [];
            
            % determine dimension of input array
            if size(cellArray, 1) == 1
                % first argument is either a column in a cell, or a cell
                % array containing the columns.
                nc = size(cellArray, 2);
                if nc == 1
                    % only one column is specified
                    % -> force the cell array encapsulation of the column
                    cellArray = {cellArray};
                end
                
                nr = size(cellArray{1}, 1);
                
            else
                % data specified as cell array of elements
                nc = size(cellArray, 2);
                nr = size(cellArray, 1);
                
                % convert 2D cell array to array of columns
                baseArray = cellArray;
                cellArray = cell(1, nc);
                for iCol = 1:nc
                    column = cell(nr, 1);
                    for iRow = 1:nr
                        column{iRow} = baseArray{iRow, iCol};
                    end
                    cellArray{iCol} = column;
                end
            end
            
            % format data table
            obj.Data = zeros(nr, nc);
            obj.Levels = cell(1, nc);
            
            % fill up each column
            for iCol = 1:nc
                % current column
                % assume a numeric, char, or cell array as column vector
                col = cellArray{iCol};
                
                if isnumeric(col) || islogical(col)
                    % all data are numeric
                    obj.Data(:, iCol)  = col;
                else
                    % convert char arrays to cell arrays
                    if ischar(col)
                        col = strtrim(cellstr(col));
                    end
                    
                    % character or cell array are used as factors
                    [levels, I, num]  = unique(col); %#ok<ASGLU>
                    obj.Data(:, iCol)  = num;
                    obj.Levels{iCol}   = levels;
                end
            end
        end
        
        
        % ---------
        % Parse row and col names
        
        % check if column names were specified
        if ~isempty(varargin)
            if iscell(varargin{1})
                if length(varargin{1}) ~= size(obj.Data,2)
                    error('Table:Table', ...
                        'Column names have %d elements, whereas table has %d columns', ...
                        length(varargin{1}), size(obj.Data,2));
                end
                obj.ColNames = varargin{1};
                varargin(1) = [];
            elseif isempty(var1)
                % propagate empty column names
                varargin(1) = [];
            end
        end
        
        % check if row names were specified
        if ~isempty(varargin)
            var1 = varargin{1};
            if iscell(var1)
                if length(var1) ~= size(obj.Data,1) && ~isempty(var1)
                    error('Number of row names does not match row number');
                end
                obj.RowNames = var1;
                varargin(1) = [];
            elseif isempty(var1)
                % propagate empty row names
                varargin(1) = [];
            end
        end
        
        
        % ---------
        % Process parent table if present
        
        if length(varargin) > 1
            ind = find(strcmpi(varargin(1:2:end), 'Parent'));
            if ~isempty(ind)
                % initialize new table with values from parent table
                ind = ind * 2 - 1;
                parent = varargin{ind+1};
                if ~isa(parent, 'Table')
                    error('When parent is specified, it should be a Table');
                end
                
                obj.ColNames    = parent.ColNames;
                obj.RowNames    = parent.RowNames;
                obj.Name        = parent.Name;
                obj.Levels      = parent.Levels;
                obj.PreferredPlotTypes = parent.PreferredPlotTypes;
                
                % remove arguments from the list
                varargin(ind:ind+1) = [];
            end
        end
        
        
        % ---------
        % parse additional arguments set using parameter name-value pairs
        
        while length(varargin) > 1
            % get parameter name and value
            param = lower(varargin{1});
            value = varargin{2};
            
            % switch
            if strcmpi(param, 'RowNames')
                if ischar(value)
                    value = strtrim(cellstr(value));
                end
                if length(value) ~= size(obj.Data,1) && ~isempty(value)
                    error('Number of row names does not match row number');
                end
                obj.RowNames = value;
                
            elseif strcmpi(param, 'ColNames')
                if ischar(value)
                    value = strtrim(cellstr(value))';
                end
                if length(value) ~= size(obj.Data,2) && ~isempty(value)
                    error('Number of column names does not match column number');
                end
                obj.ColNames = value;
                
            elseif strcmpi(param, 'Name')
                obj.Name = value;
                
            elseif strcmpi(param, 'Levels')
                if length(value) ~= size(obj.Data,2)
                    error('Number of level does not match column number');
                end
                obj.Levels = value;
                
            elseif strcmpi(param, 'PreferredPlotTypes')
                if length(value) ~= size(obj.Data,2)
                    error('Number of values does not match column number');
                end
                obj.PreferredPlotTypes = value;
                
            else
                error('Table:Table', ...
                    ['Unknown parameter name: ' varargin{1}]);
            end
            
            varargin(1:2) = [];
        end
        
        
        % ---------
        % create default values for some fields if they were not initialised
        
        % size of the data table
        nc = size(obj.Data, 2);
        
        if isempty(obj.ColNames) && nc > 0
            obj.ColNames = strtrim(cellstr(num2str((1:nc)')))';
        end
        if isempty(obj.Levels) && nc > 0
            obj.Levels = cell(1, nc);
        end
        if isempty(obj.PreferredPlotTypes) && nc > 0
            obj.PreferredPlotTypes = repmat({'line'}, 1, nc);
        end
        
    end
    
end % constructor section

end %classdef
