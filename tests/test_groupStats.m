function test_suite = test_groupStats(varargin)
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

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Iris %#ok<*DEFNU>
% Test call of function without argument
iris = Table.read('fisherIris.txt');
res = groupStats(iris(:, 1:4), iris('Species'));

exp = [3 4];
assertElementsAlmostEqual(exp, size(res));

assertTrue(iscell(res.rowNames));
assertEqual(3, length(res.rowNames));

function test_SeveralOutputs

iris = Table.read('fisherIris.txt');
stats = {@mean, @std, @numel};
[res1, res2, res3] = groupStats(iris(:, 1:4), iris('Species'), stats);

exp = [3 4];
assertElementsAlmostEqual(exp, size(res1));
assertElementsAlmostEqual(exp, size(res2));
assertElementsAlmostEqual(exp, size(res3));

