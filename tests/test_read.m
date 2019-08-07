function test_suite = test_read(varargin)
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

test_suite = buildFunctionHandleTestSuite(localfunctions);

function testReadNumeric %#ok<*DEFNU>
tab = Table.read(fullfile('files', 'file1.txt'));
assertTrue(length(tab.ColNames)==2);
assertTrue(length(tab.RowNames)==6);
assertTrue(size(tab.Data, 1)==6);
assertTrue(size(tab.Data, 2)==2);

function testReadFactors
tab = Table.read(fullfile('files', 'fileWithText.txt'));
assertTrue(length(tab.ColNames)==2);
assertTrue(length(tab.RowNames)==6);
assertTrue(size(tab.Data, 1)==6);
assertTrue(size(tab.Data, 2)==2);

% assertFalse(isempty(tab.l{1}));
% assertTrue(isempty(tab.l{2}));

% assertTrue(tableIsFactor(tab, 'var1'));
% assertFalse(tableIsFactor(tab, 'var2'));


function testReadWithoutRowNamesHeader

fileName = fullfile('files', 'fileWithoutRowNamesHeader.txt');
tab = Table.read(fileName);
assertEqual(6, size(tab, 1));
assertEqual(2, size(tab, 2));


function testReadWithDelimiterSC

tab = Table.read(fullfile('files', 'file1-delimSC.txt'), 'Delimiter', ';');

assertEqual(2, length(tab.ColNames));
assertEqual(6, length(tab.RowNames));
assertEqual(6, size(tab.Data, 1));
assertEqual(2, size(tab.Data, 2));

function testReadFleaBeetles

tab = Table.read(fullfile('files', 'fleaBeetles.txt'));

assertEqual(3, columnNumber(tab));

