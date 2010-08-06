function test_suite = test_transpose(varargin) %#ok<STOUT>
%test_transpose  One-line description here, please.
%
%   output = test_transpose(input)
%
%   Example
%   test_transpose
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

function testFunctionCall %#ok<*DEFNU>

tab = Table.read(fullfile('files', 'file1.txt'));

tab2 = tab.transpose();

assertEqual(tab.rowNumber(), tab2.columnNumber());
assertEqual(tab.columnNumber(), tab2.rowNumber());

function testSingleQuote %#ok<*DEFNU>

tab = Table.read(fullfile('files', 'file1.txt'));

tab2 = tab';

assertEqual(tab.rowNumber(), tab2.columnNumber());
assertEqual(tab.columnNumber(), tab2.rowNumber());

