function tests = test_corrcoef
% Test suite for the file corrcoef.
%
%   Test suite for the file corrcoef
%
%   Example
%   test_corrcoef
%
%   See also
%     corrcoef

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-03,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');

res = corrcoef(iris(:,1:4));

assertTrue(isa(res, 'Table'));
assertEqual(testCase, size(res), [4 4]);


function test_TwoInputs(testCase)
% Test call of function without argument.

iris = Table.read('fisherIris.txt');

res = corrcoef(iris(:,1:2), iris(:,3:4));

assertTrue(isa(res, 'Table'));
assertEqual(testCase, size(res), [2 2]);
assertEqual(testCase, res.Data(1,1), 1);
assertEqual(testCase, res.Data(2,2), 1);
