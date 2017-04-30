function test_suite = test_plotRows(varargin)
%TEST_PLOTROWS  Test case for the file plotRows
%
%   Test case for the file plotRows

%   Example
%   test_plotRows
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>
dat = ones(5, 15);
tab = Table.create(dat);

figure(1);
tab.plotRows();
close(1);

figure(1);
plotRows(tab);
close(1);

function test_WithAxis
dat = ones(5, 15);
tab = Table.create(dat);

figure(1);
ax = gca;
tab.plotRows(ax);
close(1);

figure(1);
ax = gca;
plotRows(ax, tab);
close(1);


function test_WithXData
dat = ones(5, 15);
tab = Table.create(dat);
lx = linspace(10, 20, 15);

figure(1);
plotRows(lx, tab);
close(1);

function test_WithAxisAndXData
dat = ones(5, 15);
tab = Table.create(dat);
lx = linspace(10, 20, 15);

figure(1);
ax = gca;
plotRows(ax, lx, tab);
close(1);

