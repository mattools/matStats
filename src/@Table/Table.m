classdef (InferiorClasses = {?matlab.graphics.axis.Axes}) Table < handle
%TABLE Class for data table with named rows and columns
%
%   Creation:
%   tab = Table(DATA);
%   tab = Table(DATA, 'rowNames', ROWNAMES, 'colNames', COLNAMES);
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
%   Table Methods:
%   Table creation
%   Table                   - Class for data table with named rows and columns
%   create                  - Create a new data table
%
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
%   Array manipulation
%   size                    - Size of a data table
%   length                  - Number of rows in the table.
%   horzcat                 - Concatenate tables horizontally
%   vertcat                 - Concatenate tables vertically
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
%
%   Basic statistical analyses
%   summary                 - Display a summary of the data in the table
%   stats                   - Compute basic descriptive statistics on data table columns
%   aggregate               - Group table rows according to unique values in a vector or column
%   corrcoef                - Correlation coefficients of table data
%   cov                     - Covariance matrix of the data table
%   zscore                  - Standardized z-score
%   geomean                 - Compute geometrical mean of table columns
%   ttest2                  - Two-sample t-test
%
%   Plot and display
%   disp                    - Display the content of a data table, with row and column names
%   display                 - Display the content of a data table
%   show                    - Display the content of the table in a new figure
%   plot                    - Plot the content of a column
%   errorbar                - Overload the errorbar function to manage data tables
%   histogram               - Histogram plot of a column in a data table
%   scatter                 - Scatter plot of table data
%   scatterNames            - Scatter names according to two variables
%   surf                    - Surfacic representation of the data stored in a Table
%   hist                    - Histogram plot of a column in a data table
%   boxplot                 - Box plot of a data table
%   violinPlot              - Plot distribution of data in a table
%   bar                     - Bar plot of the table data
%   plotmatrix              - Overload plotmatrix function to display column names
%   scatterLabels           - Scatter labels according to 2 variables
%   scatterPlot             - Scatter plot of two columns in a table
%   correlationCircles      - Represent correlation matrix using colored circles
%   plotRows                - Plot all the rows of the data table
%
%   Factors
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
%   parseFactorFromRowNames - Create a factor table by parsing row names
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
%
%   Utility functions
%   addColumn               - Add a new column to the data table
%   addRow                  - Add a new row to the data table
%   apply                   - Apply the given function to each element of the table
%   bsxfun                  - Binary Singleton Expansion Function for Table
%   unique                  - Returns unique values in data tables
%   concatFiles             - Concatenate a list of files containing tables into new a file
%   printLatex              - Print content of this table as a latex tabular
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % the name of the table
    name;
    
    % the name of the file used for initializing the Table
    fileName;
    
    % inner data of the table, stored in a Nr-by-Nc array of double
    data;
    
    % name of columns, stored in a 1-by-Nc cell array of strings
    colNames;
    
    % name of rows, stored in a Nr-by-1 cell array of strings
    rowNames;

    % factor levels, stored in a 1-by-Nc cell array. Each cell can be one
    % of the following:
    % * empty (column is not a factor), 
    % * a cell array of chars (column is a categorical factor), 
    % * an array of numeric values (colum is an ordered factor).
    % For columns considered as factor, the corresponding column in the
    % data array should only contain integer, whose maximum value should
    % not exceed the number of elements in the level cell.
    levels;
    
end

%% Declaration of static methods
methods (Static)
    tab = create(varargin)
    tab = read(fileName, varargin)
    varargout = concatFiles(inputFiles, outputFile, varargin)
end


%% Constructor
methods

    function this = Table(varargin)
    %Constructor for Table class
    %
    %   TAB = Table(DATA)
    %   where DATA is a numeric array, create a new data table from a
    %   numeric array.
    %
    %   TAB = Table(..., 'colNames', NAMES)
    %   Also specifies the name of columns. NAMES is a cell array with as
    %   many columns as the number of columns of the data table. 
    %
    %   TAB = Table(..., 'rowNames', NAMES)
    %   Also specifies the name of rows. NAMES is a cell array with as many
    %   rows as the number of rows of the data table. 
    %
    %   TAB = Table(..., 'name', NAME)
    %   Also specify the name of the data table. NAME is a char array.
    %  
    %   See Also
    %   Table/create
    %

        % ---------
        % Analyse the first argument, if present
        
        if nargin == 0
            % empty constructor
            this.data = [];
            this.rowNames = {};
            this.colNames = {};
            
        elseif isa(varargin{1}, 'Table')
            % copy constructor
            tab = varargin{1};
            this.data = tab.data;
            this.rowNames   = tab.rowNames;
            this.colNames   = tab.colNames;
            this.levels     = tab.levels;
            this.name       = tab.name;
            
            varargin(1) = [];
            
        elseif isnumeric(varargin{1}) || islogical(varargin{1})
            % If first argument is numeric, assume this is data array
            this.data = varargin{1};
            varargin(1) = [];
            
        elseif iscell(varargin{1})
            % create table from cell array.
            % The cell array can be either a N-by-P cell array of N rows
            % and P columns, or a cell array of columns, each columns being
            % stored as a cell array.
            
            % extract data
            cellArray = varargin{1};
            varargin(1) = [];

            % determine dimension of input array
            if iscell(cellArray{1})
                % specify an array of columns, each cell containing a
                % column
                nc = size(cellArray, 2);
                nr = length(cellArray{1});
            elseif size(cellArray, 2) == 1
                % only one column is specified
                nc = 1;
                nr = length(cellArray);
                % force the cell array encapsulation of the column
                cellArray = {cellArray};
            else
                % data specified as cell array of elements
                nc = size(cellArray, 2);
                nr = size(cellArray, 1);
                
                % convert cell array to array of columns
                tmp = cellArray;
                cellArray = cell(1, nc);
                for iCol = 1:nc
                    column = cell(nr, 1);
                    for iRow = 1:nr
                        column{iRow} = tmp{iRow, iCol};
                    end
                    cellArray{iCol} = column;
                end
            end

            % format data table
            this.data = zeros(nr, nc);
            this.levels = cell(1, nc);

            % fill up each column
            for iCol = 1:nc
                % current column
                col = cellArray{iCol};

                % convert to numeric
                num = str2double(col);

                indNan = strcmpi(col, 'na') | strcmpi(col, 'nan');

                % choose to store data as numeric values or as factors levels
                if sum(isnan(num(~indNan))) == 0
                    % all data are numeric
                    this.data(:, iCol)  = num;
                else
                    % if there are unconverted values, changes to factor levels
                    [levels, I, num]  = unique(col); %#ok<ASGLU>
                    this.data(:, iCol)  = num;
                    this.levels{iCol}   = levels;
                end
            end
        end
 
        
        % ---------
        % Parse row and col names
        
        % check if column names were specified
        if ~isempty(varargin)
            if iscell(varargin{1})
                if length(varargin{1}) ~= size(this.data,2)
                    error('Column names have %d elements, whereas table has %d columns', ...
                        length(varargin{1}), size(this.data,2));
                end
                this.colNames = varargin{1};
                varargin(1) = [];
            end
        end
        
        % check if row names were specified
        if ~isempty(varargin)
            if iscell(varargin{1})
                if length(varargin{1}) ~= size(this.data,1)
                    error('Number of row names does not match row number');
                end
                this.rowNames = varargin{1};
                varargin(1) = [];
            end
        end

        
        % ---------
        % Process parent table if present
        
        if length(varargin) > 1
            ind = find(strcmp(varargin(1:2:end), 'parent'));
            if ~isempty(ind)
                % initialize new table with values from parent
                ind = ind * 2 - 1;
                parent = varargin{ind+1};
                this.name        = parent.name;
                this.rowNames    = parent.rowNames;
                this.colNames    = parent.colNames;
                this.levels      = parent.levels;
                
                % remove argumets from the list
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
            if strcmp(param, 'rownames')
                if length(value) ~= size(this.data,1)
                     error('Number of row names does not match row number');
                end
                this.rowNames = value;
                    
            elseif strcmp(param, 'colnames')
                if length(value) ~= size(this.data,2)
                     error('Number of column names does not match column number');
                end
                this.colNames = value;

            elseif strcmp(param, 'levels')
                if length(value) ~= size(this.data,2)
                     error('Number of level does not match column number');
                end
                this.levels = value;
            
            elseif strcmp(param, 'name')
                this.name = value;
            
            else
                error('Table:Table', ...
                    ['Unknown parameter name: ' varargin{1}]);
            end
            
            varargin(1:2) = [];
        end
       
            
        % ---------
        % create default values for other fields if they were not initialised

        % size if the data table            
        nr = size(this.data, 1);
        nc = size(this.data, 2);
        
        if isempty(this.rowNames) && nr > 0
            this.rowNames = strtrim(cellstr(num2str((1:nr)')));
        end
        if isempty(this.colNames) && nc > 0
            this.colNames = strtrim(cellstr(num2str((1:nc)')))';
        end
        if isempty(this.levels) && nc > 0
            this.levels = cell(1, nc);
        end    

    end
    
end % constructor section


end %classdef
