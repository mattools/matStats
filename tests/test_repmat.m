function tests = test_repmat
% Test suite for the file repmat.
%
%   Test suite for the file repmat
%
%   Example
%   test_repmat
%
%   See also
%     repmat

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-04-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table([1 2 3 ; 4 5 6], {'C1', 'C2', 'C3'});

tab22 = repmat(tab, 2, 2);

assertEqual(testCase, [4 6], size(tab22));


function test_WithFactors(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');

tab2 = repmat(iris, 1, 2);

assertEqual(testCase, [150 10], size(tab2));
assertTrue(testCase, isFactor(tab2, 10));
