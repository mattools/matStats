function tests = test_median
% Test suite for the file median.
%
%   Test suite for the file median
%
%   Example
%   test_median
%
%   See also
%     median

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = magic(5);
tab = Table(data);

res = median(tab);

assertTrue(testCase, isa(res, 'Table'));
assertEqual(testCase, res.Data, median(data), 'AbsTol', .01);
