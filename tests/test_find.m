function test_suite = test_find(varargin) %#ok<STOUT>
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

initTestSuite;

function test_nargout1 %#ok<*DEFNU>

tab = Table(magic(4));
ind = find(tab == 12);
assertEqual(15, ind);


function test_nargout2

tab = Table(magic(4));
[r c] = find(tab == 12);
assertEqual(3, r);
assertEqual(4, c);


