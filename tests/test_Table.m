function tests = test_Table
%TESTTABLE  One-line description here, please.
%
%   output = testTable(input)
%
%   Example
%   testTable
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


tests = functiontests(localfunctions);


function testCreateFromNumericalArray(testCase) %#ok<*DEFNU>

array = randi(10, [10 4]);
tab = Table(array);

assertTrue(testCase, isa(tab, 'Table'));

% test subsref and subsasgn
tab(2, 3) = 10;
assertEqual(testCase, 10, tab(2, 3).Data);


function testCreateFromCellArray_singleColumn(testCase)

cellArray = {'A'; 'B'; 'C'};

tab = Table(cellArray);

assertTrue(testCase, isa(tab, 'Table'));
assertEqual(testCase, 3, size(tab, 1));
assertEqual(testCase, 1, size(tab, 2));


function testCreateFromCellArray_TwoColumns(testCase)

cellArray = {{'A'; 'B'; 'C'}, [1; 2; 3]};

tab = Table(cellArray);

assertTrue(testCase, isa(tab, 'Table'));
assertEqual(testCase, 3, size(tab, 1));
assertEqual(testCase, 2, size(tab, 2));
assertTrue(testCase, strcmp('A', getLevel(tab, 1, 1)));
assertEqual(testCase, 3, getValue(tab, 3, 2));


function testCreateFromCellArray_carsmall(testCase)

set = load('carsmall');

tab = Table({set.Origin, set.MPG, set.Cylinders, set.Displacement});

assertTrue(testCase, isa(tab, 'Table'));
assertEqual(testCase, 100, size(tab, 1));
assertEqual(testCase, 4, size(tab, 2));
assertTrue(testCase, strcmp('USA', getLevel(tab, 1, 1)));
assertEqual(testCase, 302, getValue(tab, 5, 4));


function testCreateSetColNames(testCase)

names = strtrim(cellstr(num2str((1:4)', 'i%d')))';
array = randi(10, [10 4]);

tab = Table(array, names);
assertEqual(testCase, names, tab.ColNames);

tab = Table(array, 'colNames', names);
assertEqual(testCase, names, tab.ColNames);


function testCreateSetRowNames(testCase)

names = strtrim(cellstr(num2str((1:10)', 'i%d')));
array = randi(10, [10 4]);

tab = Table(array, 'rowNames', names);
assertEqual(testCase, names, tab.RowNames);


function testCreate_ColumnList(testCase)
% creates a table from several named variables.
% The column names should be set automatically.

t = [0 1 2 3]';
xt = [10 20 30 40]';
yt = [12 8 10 14]';

tab = Table(t, xt, yt);
assertEqual(testCase, [4 3], size(tab));
assertEqual(testCase, 'xt', tab.ColNames{2});


function testCreate_ColumnList_WithRowNames(testCase)
% creates a table from several named variables.
% The column names should be set automatically.

t = [0 1 2 3]';
xt = [10 20 30 40]';
yt = [12 8 10 14]';
rowNames = {'row1', 'row2','row3', 'row4'}';

tab = Table(t, xt, yt, 'rowNames', rowNames);
assertEqual(testCase, [4 3], size(tab));
assertEqual(testCase, 'xt', tab.ColNames{2});
assertEqual(testCase, 'row3', tab.RowNames{3});

