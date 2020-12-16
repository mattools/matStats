function tests = test_stairStepsPlot
% Test suite for the file stairStepsPlot.
%
%   Test suite for the file stairStepsPlot
%
%   Example
%   test_stairStepsPlot
%
%   See also
%     stairStepsPlot

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-16,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table(magic(4));
hFig = figure;

h = stairStepsPlot(tab);

assertTrue(testCase, ishandle(h(1)));

close(hFig);


function test_SpecifyAxisHandle(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table(magic(4));
hFig = figure;
ax = gca;

h = stairStepsPlot(ax, tab);

assertTrue(testCase, ishandle(h(1)));

close(hFig);
