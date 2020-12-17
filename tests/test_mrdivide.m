function tests = test_mrdivide
% Test suite for the file mrdivide.
%
%   Test suite for the file mrdivide
%
%   Example
%   test_mrdivide
%
%   See also
%     test_mrdivide

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = createTable();

res = tab / 10;

exp = tab.Data(2, 3) / 10;
assertEqual(testCase, res.Data(2, 3), exp);


function test_TwoArrays(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab1 = createTable();
tab2 = createTable()';

res = tab1 / tab2;

exp = tab1.Data(2, 3) / tab2.Data(2, 3);
assertEqual(testCase, res.Data(2, 3), exp);



function tab = createTable()

data = magic(4);
tab = Table(data);
