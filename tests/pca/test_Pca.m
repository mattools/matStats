function tests = test_Pca
% Test suite for the file Pca.
%
%   Test suite for the file Pca
%
%   Example
%   test_Pca
%
%   See also
%     Pca

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-03,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_iris(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');
irisData = iris(:,1:4);

resPca = Pca(irisData, 'scale', true, 'display', false);

% check class
assertTrue(testCase, isa(resPca, 'Pca'));
% check size of inner results (150 obs, 4 features,  components)
assertEqual(testCase, size(resPca.Means), [1 4]);
assertEqual(testCase, size(resPca.Scores), [150 4]);
assertEqual(testCase, size(resPca.Loadings), [4 4]);
assertEqual(testCase, size(resPca.EigenValues), [4 3]);

