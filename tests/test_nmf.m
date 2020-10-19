function tests = test_nmf
% Test suite for the file nmf.
%
%   Test suite for the file nmf
%
%   Example
%   test_nmf
%
%   See also
%     nmf

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-03,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_iris(testCase) %#ok<*DEFNU>
% Test call of function without argument.
      
iris = Table.read('fisherIris');
NC = 2;

[W, H] = nmf(iris(:,1:4), NC);

assertEqual(testCase, size(W), [150 NC]);
assertEqual(testCase, size(H), [NC 4]);
