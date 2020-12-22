function tests = test_pairPlot
% Test suite for the file pairPlot.
%
%   Test suite for the file pairPlot
%
%   Example
%   test_pairPlot
%
%   See also
%     pairPlot

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-22,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Iris(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris');
hFig = figure;

pairPlot(iris(:,1:4));

close(hFig);


function test_Iris_bySpecies(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris');
hFig = figure;

pairPlot(iris(:,1:4), iris(:,5));

close(hFig);

