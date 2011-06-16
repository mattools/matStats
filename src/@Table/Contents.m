% TABLE Data Table Class
%   Version 0.0.1 16-June-2011 .
%
%   Table is a class for manipulating data tables.
%
%
%   Table creation
%   Table         - Class for data table with named rows and columns
%   create        - Create a new data table
%
%   Files
%   columnIndex   - Index of a column from its name
%   isColumnName  - Check if the table contains a column with the given name
%   columnNumber  - Number of columns in the table
%   getColumn     - Extract column data of the table
%   rowIndex      - Index of a row from its name
%   rowNumber     - Number of rows in the table
%   getRow        - Extract row data of the table
%
%   File I/O
%   read          - Read a datatable file
%   write         - Write a datatable into a file
%
%   Overloaded functions
%   size          - Size of a data table
%   horzcat       - Concatenate tables horizontally
%   vertcat       - Concatenate tables vertically
%   transpose     - Transpose a data table and intervert names of row and columns
%   ctranspose    - Simple wrapper to transpose function to comply with ' syntax
%   end           - Determine last index when accessing a table
%   subsasgn      - Overrides subsasgn function for Image objects
%   subsref       - Overrides subsref function for Table objects
%
%   Basic statistical analyses
%   summary       - Display a summary of the data in the table
%   stats         - Compute basic descriptive statistics on data table columns
%   groupByLevels - Group rows according to unique values in a vector or column
%
%   Plot and display
%   show          - Display the content of the table in a new figure
%   plot          - Plot the content of a column
%   histogram     - Histogram plot of a column in a data table
%   scatter       - Scatter plot of two columns in a table
%
