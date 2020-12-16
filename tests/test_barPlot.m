function tests = test_barPlot
% Test suite for the file barPlot.
%
%   Test suite for the file barPlot
%
%   Example
%   test_barPlot
%
%   See also
%     barPlot

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-15,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table(magic(4));
hFig = figure;

h = barPlot(tab);

assertTrue(testCase, ishandle(h(1)));

close(hFig);


function test_SpecifyAxisHandle(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table(magic(4));
hFig = figure;
ax = gca;

h = barPlot(ax, tab);

assertTrue(testCase, ishandle(h(1)));

close(hFig);
