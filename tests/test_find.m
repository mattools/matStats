function tests = test_find(varargin)
%TEST_FIND  Test case for the file find
%
%   Test case for the file find

%   Example
%   test_find
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_nargout1(testCase) %#ok<*DEFNU>

tab = Table.create(magic(4));
ind = find(tab == 12);
assertEqual(testCase, 15, ind);


function test_nargout2(testCase)

tab = Table.create(magic(4));
[r, c] = find(tab == 12);
assertEqual(testCase, 3, r);
assertEqual(testCase, 4, c);


