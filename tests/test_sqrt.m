function tests = test_sqrt
% Test suite for the file sqrt.
%
%   Test suite for the file sqrt
%
%   Example
%   test_sqrt
%
%   See also
%     sqrt

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = createTable();

res = sqrt(tab);

expected = sqrt(tab.Data(2, 3));
assertEqual(testCase, res.Data(2, 3), expected);


function tab = createTable()

data = magic(4);
tab = Table(data);
