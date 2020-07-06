function tests = test_horzcat(varargin) 
%test_horzcat  One-line description here, please.
%
%   output = test_horzcat(input)
%
%   Example
%   test_horzcat
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

function testTwoTables(testCase) %#ok<*DEFNU>

array1 = randi(10, [10 4]);
tab1 = Table.create(array1);

array2 = randi(10, [10 3]);
tab2 = Table.create(array2);

res = [tab1 tab2];
assertEqual(testCase, [10 7], size(res.Data));
