function  test_suite = test_isColumnName(varargin) %#ok<STOUT>
%TEST_ISCOLUMNNAME  One-line description here, please.
%
%   output = test_isColumnName(input)
%
%   Example
%   test_isColumnName
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

initTestSuite;

function testOneColumnName %#ok<*DEFNU>

tab = Table.read('demo1.txt');

assertTrue(isColumnName(tab, 'sint'));


function testCharArray

tab = Table.read('demo1.txt');

exp = logical([1;0;1;0]);
res = isColumnName(tab, strvcat('sint', 'cos', 't', 'sin')); %#ok<VCAT>
assertEqual(exp, res);


function testCellArray

tab = Table.read('demo1.txt');

exp = logical([1;0;1;0]);
res = isColumnName(tab, {'sint', 'cos', 't', 'sin'});
assertEqual(exp, res);


function testNumeric

tab = Table.read('demo1.txt');

exp = logical([1 1 1 0]);
res = isColumnName(tab, [1 2 3 4]);
assertEqual(exp, res);

