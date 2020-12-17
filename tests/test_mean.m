function tests = test_mean
% Test suite for the file mean.
%
%   Test suite for the file mean
%
%   Example
%   test_mean
%
%   See also
%     mean

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-17,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = magic(4);
tab = Table(data);

res = mean(tab);

assertTrue(testCase, isa(res, 'Table'));
assertEqual(testCase, res.Data, mean(data), 'AbsTol', .01);
