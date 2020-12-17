function tests = test_log2
% Test suite for the file log2.
%
%   Test suite for the file log2
%
%   Example
%   test_log2
%
%   See also
%     log2

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = createTable();

res = log2(tab);

expected = log2(tab.Data(2, 3));
assertEqual(testCase, res.Data(2, 3), expected);


function tab = createTable()

data = magic(4);
tab = Table(data);
