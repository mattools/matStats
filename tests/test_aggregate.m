function tests = test_aggregate
% Test suite for the file aggregate.
%
%   Test suite for the file aggregate
%
%   Example
%   test_aggregate
%
%   See also
%     aggregate

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-13,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>

iris = Table.read('fisherIris.txt');

res = aggregate(iris(:,1:4), iris('Species'), @mean);

% results in a table with 3 rows (3 classes) and 4 columns( 4 features)
assertEqual(testCase, size(res), [3 4]);

