function test_suite = test_subsasgn(varargin)
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

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>
% Test call of function without argument

iris = Table.read('fisherIris.txt');
assertEqual(3.2, iris(3, 2).Data);
iris(3, 2) = 2.6;
assertEqual(2.6, iris(3, 2).Data);

function test_Column

iris = Table.read('fisherIris.txt');
assertEqual(3.2, iris(3, 2).Data);
iris(1:4, 2) = 1.1;
assertEqual(1.1, iris(1, 2).Data);
assertEqual(1.1, iris(2, 2).Data);
assertEqual(1.1, iris(3, 2).Data);
assertEqual(1.1, iris(4, 2).Data);

function test_ColumnColon

iris = Table.read('fisherIris.txt');
assertEqual(3.2, iris(3, 2).Data);
iris(:, 2) = 1.1;
assertEqual(1.1, iris(1, 2).Data);
assertEqual(1.1, iris(2, 2).Data);
assertEqual(1.1, iris(5, 2).Data);
assertEqual(1.1, iris(end, 2).Data);

function test_Row

iris = Table.read('fisherIris.txt');
assertEqual(3.2, iris(3, 2).Data);
iris(3, 1:4) = 1.1;
assertEqual(1.1, iris(3, 1).Data);
assertEqual(1.1, iris(3, 2).Data);
assertEqual(1.1, iris(3, 3).Data);
assertEqual(1.1, iris(3, 4).Data);

function test_RowColon

iris = Table.read('fisherIris.txt');
iris = iris(:,1:4);

assertEqual(3.2, iris(3, 2).Data);
iris(3, :) = 1.1;
assertEqual(1.1, iris(3, 1).Data);
assertEqual(1.1, iris(3, 2).Data);
assertEqual(1.1, iris(3, 3).Data);
assertEqual(1.1, iris(3, 4).Data);

function test_LevelAsChar

iris = Table.read('fisherIris.txt');
assertEqual(1, iris(3, 'Species').Data);
iris(3, 'Species') = 'Virginica';
assertEqual(3, iris(3, 'Species').Data);

