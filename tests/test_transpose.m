function tests = test_transpose(varargin) 
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


tests = functiontests(localfunctions);


function testFunctionCall(testCase) %#ok<*DEFNU>

tab = Table.read(fullfile('files', 'file1.txt'));

tab2 = transpose(tab);

assertEqual(testCase, rowNumber(tab), columnNumber(tab2));
assertEqual(testCase, columnNumber(tab), rowNumber(tab2));


function testSingleQuote(testCase) %#ok<*DEFNU>

tab = Table.read(fullfile('files', 'file1.txt'));

tab2 = tab';

assertEqual(testCase, rowNumber(tab), columnNumber(tab2));
assertEqual(testCase, columnNumber(tab), rowNumber(tab2));

