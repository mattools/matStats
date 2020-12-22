function tests = test_scatterPlot
% Test suite for the file scatterPlot.
%
%   Test suite for the file scatterPlot
%
%   Example
%   test_scatterPlot
%
%   See also
%     scatterPlot

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-22,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple_Iris(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');
hFig = figure; 

scatterPlot(iris('PetalWidth'), iris('PetalLength'));

close(hFig);


function test_ScatterFactor_Iris(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris.txt');
hFig = figure; 

scatterPlot(iris('Species'), iris('PetalLength'), 's');

close(hFig);
