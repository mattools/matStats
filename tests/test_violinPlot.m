function tests = test_violinPlot
% Test suite for the file violinPlot.
%
%   Test suite for the file violinPlot
%
%   Example
%   test_violinPlot
%
%   See also
%     violinPlot

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

violinPlot(tab);

close(hFig);


function test_SpecifyAxisHandle(testCase) %#ok<*DEFNU>
% Test call of function without argument.

tab = Table(magic(4));
hFig = figure;
ax = gca;

violinPlot(ax, tab);

close(hFig);
