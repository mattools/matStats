function tests = test_transform
% Test suite for the file transform.
%
%   Test suite for the file transform
%
%   Example
%   test_transform
%
%   See also
%     transform

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');
irisData = iris(:,1:4);

resPca = Pca(irisData, 'Display', false);
res = transform(resPca, irisData);

assertEqual(testCase, res.Data, resPca.Scores.Data, 'AbsTol', .0001);

