function tests = test_reconstruct
% Test suite for the file reconstruct.
%
%   Test suite for the file reconstruct
%
%   Example
%   test_reconstruct
%
%   See also
%     reconstruct

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-03,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');
irisData = iris(:,1:4);

resPca = Pca(irisData, 'scale', true, 'display', false);
rec = reconstruct(resPca, [0 0 ; 3 0; -3 0]);

% check class
assertTrue(testCase, isa(rec, 'Table'));
assertEqual(testCase, size(rec), [3 4]);
assertEqual(testCase, rec.ColNames, irisData.ColNames);

