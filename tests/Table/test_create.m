function tests = test_create(varargin)
%TEST_create  One-line description here, please.
%
%   output = testTable(input)
%
%   Example
%   testTable
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


tests = functiontests(localfunctions);

function testCreateFromArray(testCase) %#ok<*DEFNU>

array = randi(10, [10 4]);
tab = Table.create(array);

assertTrue(testCase, isa(tab, 'Table'));

% test subsref and subsasgn
tab(2, 3) = 10;
assertEqual(testCase, 10, tab(2, 3).Data);


function testCreateFromStruct(testCase)

str = load('carsmall');

tab = Table.create(str);

assertEqual(testCase, 100, size(tab, 1));
assertEqual(testCase, 10, size(tab, 2));


function testCreateFromStructArray(testCase)

lbl = logical(imread('coins.png') > 100);
props = regionprops(lbl, {'Area', 'EquivDiameter', 'Eccentricity'});

tab = Table.create(props);

assertEqual(testCase, 10, size(tab, 1));
assertEqual(testCase, 3, size(tab, 2));

