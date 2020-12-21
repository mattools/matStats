function tests = test_fit
% Test suite for the file fit.
%
%   Test suite for the file fit
%
%   Example
%   test_fit
%
%   See also
%     fit

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_fit_iris(testCase) %#ok<*DEFNU>
% test call of the fit method

iris = Table.read('fisherIris.txt');
irisData = iris(:,1:4);

resPca = Pca;
resPca.fit(irisData);

assertTrue(testCase, isa(resPca, 'Pca'));
assertFalse(testCase, isempty(resPca.Loadings));
