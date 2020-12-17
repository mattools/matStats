function tests = test_subsref
% Test suite for the file subsref.
%
%   Test suite for the file subsref
%
%   Example
%   test_subsref
%
%   See also
%     subsref

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_SelectColumns(testCase) %#ok<*DEFNU>
% select the two middle columns of a 4x4 Table, and check size

tab = createTable();
tab2 = tab(:,2:3);
assertEqual(testCase, size(tab2), [4 2]);


function test_SelectRows(testCase) %#ok<*DEFNU>
% select the two middle rows of a 4x4 Table, and check size

tab = createTable();
tab2 = tab(2:3, :);
assertEqual(testCase, size(tab2), [2 4]);


function tab = createTable()

data = magic(4);
tab = Table(data);
