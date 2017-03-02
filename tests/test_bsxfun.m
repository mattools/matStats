function test_suite = test_bsxfun(varargin)
%TEST_BSXFUN  Test case for the file bsxfun
%
%   Test case for the file bsxfun

%   Example
%   test_bsxfun
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-08-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>

tab = Table.read('fisherIris.txt');
tab = tab(:, 1:end-1);

means = tab;

res = bsxfun(@minus, tab, means);

assertEqual(size(tab), size(res));

