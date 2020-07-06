function tests = test_groupStats(varargin)
%TEST_GROUPSTATS  Test case for the file groupStats
%
%   Test case for the file groupStats

%   Example
%   test_groupStats
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);


function test_Iris(testCase) %#ok<*DEFNU>
% Test call of function without argument
iris = Table.read('fisherIris.txt');
res = groupStats(iris(:, 1:4), iris('Species'));

exp = [3 4];
assertEqual(testCase, exp, size(res));

assertTrue(testCase, iscell(res.RowNames));
assertEqual(testCase, 3, length(res.RowNames));


function test_SeveralOutputs(testCase)

iris = Table.read('fisherIris.txt');
stats = {@mean, @std, @numel};
[res1, res2, res3] = groupStats(iris(:, 1:4), iris('Species'), stats);

exp = [3 4];
assertEqual(testCase, exp, size(res1));
assertEqual(testCase, exp, size(res2));
assertEqual(testCase, exp, size(res3));

