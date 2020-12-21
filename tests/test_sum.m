function tests = test_sum
% Test suite for the file sum.
%
%   Test suite for the file sum
%
%   Example
%   test_sum
%
%   See also
%     sum

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = magic(4);
tab = Table(data);

res = sum(tab);

assertTrue(testCase, isa(res, 'Table'));
assertEqual(testCase, res.Data, sum(data), 'AbsTol', .01);
