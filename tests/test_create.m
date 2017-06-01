function test_suite = test_create(varargin)
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


test_suite = buildFunctionHandleTestSuite(localfunctions);

function testCreateFromArray %#ok<*DEFNU>

array = randi(10, [10 4]);
tab = Table.create(array);

assertTrue(isa(tab, 'Table'));

% test subsref and subsasgn
tab(2, 3) = 10;
assertEqual(10, tab(2, 3).data);


function testCreateFromStruct

str = load('carsmall');

tab = Table.create(str);

assertEqual(100, size(tab, 1));
assertEqual(10, size(tab, 2));


function testCreateFromStructArray

lbl = logical(imread('coins.png') > 100);
props = regionprops(lbl, {'Area', 'EquivDiameter', 'Eccentricity'});

tab = Table.create(props);

assertEqual(10, size(tab, 1));
assertEqual(3, size(tab, 2));

