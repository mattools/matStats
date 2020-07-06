function tests = test_read(varargin)
%TEST_READ  One-line description here, please.
%   output = test_read(input)
%
%   Example
%   test_read
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-07-01,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);


function testReadNumeric(testCase) %#ok<*DEFNU>
tab = Table.read(fullfile('files', 'file1.txt'));
assertEqual(testCase, 2, length(tab.ColNames));
assertEqual(testCase, 6, length(tab.RowNames));
assertEqual(testCase, 6, size(tab.Data, 1));
assertEqual(testCase, 2, size(tab.Data, 2));


function testReadFactors(testCase)
tab = Table.read(fullfile('files', 'fileWithText.txt'));
assertEqual(testCase, 2, length(tab.ColNames));
assertEqual(testCase, 6, length(tab.RowNames));
assertEqual(testCase, 6, size(tab.Data, 1));
assertEqual(testCase, 2, size(tab.Data, 2));

% assertFalse(isempty(tab.l{1}));
% assertTrue(isempty(tab.l{2}));

% assertTrue(tableIsFactor(tab, 'var1'));
% assertFalse(tableIsFactor(tab, 'var2'));


function testReadWithoutRowNamesHeader(testCase)

fileName = fullfile('files', 'fileWithoutRowNamesHeader.txt');
tab = Table.read(fileName);
assertEqual(testCase, 6, size(tab, 1));
assertEqual(testCase, 2, size(tab, 2));


function testReadWithDelimiterSC(testCase)

tab = Table.read(fullfile('files', 'file1-delimSC.txt'), 'Delimiter', ';');

assertEqual(testCase, 2, length(tab.ColNames));
assertEqual(testCase, 6, length(tab.RowNames));
assertEqual(testCase, 6, size(tab.Data, 1));
assertEqual(testCase, 2, size(tab.Data, 2));


function testReadFleaBeetles(testCase)

tab = Table.read(fullfile('files', 'fleaBeetles.txt'));

assertEqual(testCase, 3, columnNumber(tab));

