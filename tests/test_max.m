function tests = test_max
% Test suite for the file max.
%
%   Test suite for the file max
%
%   Example
%   test_max
%
%   See also
%     max

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

res = max(tab);

assertTrue(testCase, isa(res, 'Table'));
assertEqual(testCase, res.Data, max(data), 'AbsTol', .01);

