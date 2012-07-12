% TABLE Data Table Class
%   Version 0.0.1 16-June-2011 .
%
%   Table is a class for manipulating data tables.
%
%
%   Table creation
%   Table                   - Class for data table with named rows and columns
%   create                  - Create a new data table
%
%   Files
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
%   round                   - RES Round values in the table
%   ceil                    - RES Ceil values in the table
%   floor                   - RES Floor values in the table
%   exp                     - Exponential of table values
%   log                     - Logarithm of table values
%   log10                   - Decimal logarithm of table values
%   log2                    - LOG Binary logarithm of table values
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
%   power                   - MPOWER Overload the power operator for Table objects
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
%   corrcoef                - Correlation coefficients of table data
%   cov                     - Covariance matrix of the data table
%   zscore                  - Standardized z-score
%   geomean                 - Compute geometrical mean of table columns
%
%
%   Factors
%   setAsFactor             - Set the given column as a factor
%   isFactor                - Check if a column is treated as a factor
%   setFactorLevels         - Set up the levels of a factor in a table
%   factorLevels            - List of the levels for a given factor
%   hasFactors              - Check if the table has column(s) representing factor(s)
%   clearFactors            - Replace all factor columns by numeric columns
%   parseFactorFromRowNames - Create a factor table by parsing row names
%   plotGroupErrorBars      - One-line description here, please.
%   plotGroupMeans          - One-line description here, please.
%   plotGroupRows           - Plot data table rows with different style by group
%   plotGroups              - Display data ordererd by their group levels
%
%   Plot and display
%   disp                    - Display the content of a data table, with row and column names
%   display                 - Display the content of a data table
%   show                    - Display the content of the table in a new figure
%   plot                    - Plot the content of a column
%   errorbar                - Overload the errorbar function to manage data tables
%   histogram               - Histogram plot of a column in a data table
%   scatter                 - Scatter plot of table data
%   surf                    - Surfacic representation of the data stored in a Table
%   hist                    - Histogram plot of a column in a data table
%   boxplot                 - Box plot of a data table
%   bar                     - Bar plot of the table data
%   plotmatrix              - Overload plotmatrix function to display column names
%   scatterGroup            - TABLEPLOTCLASSES scatter plot individuals grouped by classes
%   scatterLabels           - SCATTERNAME Scatter labels according to 2 variables
%   scatterPlot             - Scatter plot of two columns in a table
%   plotRows                - Plot all the rows of the data table
%


%   Not yet integrated
%   addColumn               - Add a new column to the data table
%   aggregate               - Group table rows according to unique values in a vector or column
%   groupStats              - Compute basic statistics for each level of a group
%   groupStatsOld           - GROUPSTATS Compute descriptive stats for each level of a factor column
%   groupfun                - Aggregate table values according to levels of a group

