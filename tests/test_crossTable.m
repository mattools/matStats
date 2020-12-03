function tests = test_crossTable
% Test suite for the file crossTable.
%
%   Test suite for the file crossTable
%
%   Example
%   test_crossTable
%
%   See also
%     crossTable

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-03,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% create two tables, with 3 and 4 different values respectively
tab1 = Table([1 1 2 3 1]', {'x'});
tab2 = Table([1 2 5 3 1]', {'y'});

xtab = crossTable(tab1, tab2);

assertEqual(testCase, size(xtab), [3 4]);
assertEqual(testCase, xtab.Data(1,1), 2);
assertEqual(testCase, xtab.Data(2,4), 1);


function test_confusionMatrix_iris_kmeans(testCase)

iris = Table.read('fisherIris.txt');
species = iris('Species');
rng(42);
km3 = kmeans(iris(:,1:4), 3);

xtab = crossTable(iris('Species'), km3);

assertEqual(testCase, size(xtab), [3 3]);
% should keep level names of first table as new row names
assertEqual(testCase, xtab.RowNames, species.Levels{1});
