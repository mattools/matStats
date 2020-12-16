function tests = test_linePlot
% Test suite for the file linePlot.
%
%   Test suite for the file linePlot
%
%   Example
%   test_linePlot
%
%   See also
%     linePlot

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

h = linePlot(tab);

assertTrue(testCase, ishandle(h(1)));

close(hFig);


function test_SpecifyAxisHandle(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table(magic(4));
hFig = figure;
ax = gca;

h = linePlot(ax, tab);

assertTrue(testCase, ishandle(h(1)));

close(hFig);

