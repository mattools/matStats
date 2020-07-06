function tests = test_subsasgn(varargin)
%TEST_SUBSASGN  Test case for the file subsasgn
%
%   Test case for the file subsasgn

%   Example
%   test_subsasgn
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-10-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument

iris = Table.read('fisherIris.txt');
assertEqual(testCase, 3.2, iris(3, 2).Data);
iris(3, 2) = 2.6;
assertEqual(testCase, 2.6, iris(3, 2).Data);

function test_Column(testCase)

iris = Table.read('fisherIris.txt');
assertEqual(testCase, 3.2, iris(3, 2).Data);
iris(1:4, 2) = 1.1;
assertEqual(testCase, 1.1, iris(1, 2).Data);
assertEqual(testCase, 1.1, iris(2, 2).Data);
assertEqual(testCase, 1.1, iris(3, 2).Data);
assertEqual(testCase, 1.1, iris(4, 2).Data);

function test_ColumnColon(testCase)

iris = Table.read('fisherIris.txt');
assertEqual(testCase, 3.2, iris(3, 2).Data);
iris(:, 2) = 1.1;
assertEqual(testCase, 1.1, iris(1, 2).Data);
assertEqual(testCase, 1.1, iris(2, 2).Data);
assertEqual(testCase, 1.1, iris(5, 2).Data);
assertEqual(testCase, 1.1, iris(end, 2).Data);

function test_Row(testCase)

iris = Table.read('fisherIris.txt');
assertEqual(testCase, 3.2, iris(3, 2).Data);
iris(3, 1:4) = 1.1;
assertEqual(testCase, 1.1, iris(3, 1).Data);
assertEqual(testCase, 1.1, iris(3, 2).Data);
assertEqual(testCase, 1.1, iris(3, 3).Data);
assertEqual(testCase, 1.1, iris(3, 4).Data);

function test_RowColon(testCase)

iris = Table.read('fisherIris.txt');
iris = iris(:,1:4);

assertEqual(testCase, 3.2, iris(3, 2).Data);
iris(3, :) = 1.1;
assertEqual(testCase, 1.1, iris(3, 1).Data);
assertEqual(testCase, 1.1, iris(3, 2).Data);
assertEqual(testCase, 1.1, iris(3, 3).Data);
assertEqual(testCase, 1.1, iris(3, 4).Data);

function test_LevelAsChar(testCase)

iris = Table.read('fisherIris.txt');
assertEqual(testCase, 1, iris(3, 'Species').Data);
iris(3, 'Species') = 'Virginica';
assertEqual(testCase, 3, iris(3, 'Species').Data);

