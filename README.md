# matStats
A Matlab Toolbox for Data Exploration and Analysis, based on a data table class.

The toolbox is organized around a **Table** class, similar to the dataframe in R,  which encapsulates data array together with row names, column names, table name. It also supports factor columns, such as categorical factors ("yes", "no"). Several utility methods are provided, and many plot functions have been override to automatically annotate the resulting plots with table meta-data when appropriate.

The toolbox also contains facilities for statistical analysis of data tables, such as principal component analysis, analysis of variance, or linear discriminant analysis. Again, intuitive methods are povided for exploring and analysing the results by taking into account the names of the rows or of the columns.

A presentation of the library is provided in the [matStats-manual.pdf](https://github.com/mattools/matStats/releases/download/v1.0/matStats-manual-1.0.pdf) document.

Installation
---
To install the toolbox:
* download the zip archive of the [latest release](https://github.com/mattools/matStats/releases/latest)
* unzip the file
* add the 'matStats' directory to the Matlab path (see the "addpath" function from Matlab).

Some demontration scripts are provided in the "demo" directory.
