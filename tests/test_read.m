function test_suite = test_read(varargin)
%TEST_READ  One-line description here, please.
%   output = test_read(input)
%
%   Example
%   test_read
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-07-01,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

initTestSuite;

function testReadNumeric
tab = Table.read(fullfile('files', 'file1.txt'));
assertTrue(length(tab.colNames)==2);
assertTrue(length(tab.rowNames)==6);
assertTrue(size(tab.data, 1)==6);
assertTrue(size(tab.data, 2)==2);

function testReadFactors
tab = Table.read(fullfile('files', 'fileWithText.txt'));
assertTrue(length(tab.colNames)==2);
assertTrue(length(tab.rowNames)==6);
assertTrue(size(tab.data, 1)==6);
assertTrue(size(tab.data, 2)==2);

% assertFalse(isempty(tab.l{1}));
% assertTrue(isempty(tab.l{2}));

% assertTrue(tableIsFactor(tab, 'var1'));
% assertFalse(tableIsFactor(tab, 'var2'));
