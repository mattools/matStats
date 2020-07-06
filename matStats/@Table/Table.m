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
    
end


%% Declaration of static methods
methods (Static)
    tab = create(varargin)
    tab = read(fileName, varargin)
    varargout = concatFiles(inputFiles, outputFile, varargin)
end


%% Constructor
methods
    function obj = Table(varargin)
        % Constructor for Table class.
        %
        %   The constructor should not be called directly, only from derived
        %   classes.
        %
        %   See Also
        %     DataTable, Table/create
        %
    end
    
end % constructor section

end %classdef
