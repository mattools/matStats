function tests = test_zscore
% Test suite for the file zscore.
%
%   Test suite for the file zscore
%
%   Example
%   test_zscore
%
%   See also
%     zscore

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-04-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');
irisData = iris(:,1:4);

res = zscore(irisData);

assertEqual(testCase, [0 0 0 0], mean(res.Data), 'AbsTol', 0.01);
assertEqual(testCase, [1.0 1.0 1.0 1.0], std(res.Data), 'AbsTol', 0.01);
