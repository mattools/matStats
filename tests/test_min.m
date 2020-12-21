function tests = test_min
% Test suite for the file min.
%
%   Test suite for the file min
%
%   Example
%   test_min
%
%   See also
%     min

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

res = min(tab);

assertTrue(testCase, isa(res, 'Table'));
assertEqual(testCase, res.Data, min(data), 'AbsTol', .01);

