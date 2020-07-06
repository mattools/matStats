function tests = test_combineFactors
% Test suite for the file combineFactors.
%
%   Test suite for the file combineFactors
%
%   Example
%   test_combineFactors
%
%   See also
%     combineFactors

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-06,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = [1 1; 1 2; 1 1; 1 2; 2 3; 2 4; 2 3];
tab = Table.create(data, {'group1', 'group2'});
tab.setAsFactor([1 2]);

combi = combineFactors(tab(:, [1 2]));

assertEqual(testCase, size(combi, 1), 7);
assertEqual(testCase, size(combi, 2), 1);
assertTrue(testCase, isFactor(combi, 1));

