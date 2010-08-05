function test_suite = testTable(varargin)
%TESTTABLE  One-line description here, please.
%
%   output = testTable(input)
%
%   Example
%   testTable
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


initTestSuite;

function testCreateFromArray %#ok<*DEFNU>

array = randi(10, [10 4]);
tab = Table(array);

assertTrue(isa(tab, 'Table'));

% test subsref and subsasgn
tab(2, 3) = 10;
assertEqual(10, tab(2, 3));


function testCreateSetColNames

names = strtrim(cellstr(num2str((1:4)', 'i%d')));
array = randi(10, [10 4]);

tab = Table(array, names);
assertEqual(names, tab.colNames);

tab = Table(array, 'colNames', names);
assertEqual(names, tab.colNames);


function testCreateSetRowNames

names = strtrim(cellstr(num2str((1:10)', 'i%d')));
array = randi(10, [10 4]);

tab = Table(array, 'rowNames', names);
assertEqual(names, tab.rowNames);

