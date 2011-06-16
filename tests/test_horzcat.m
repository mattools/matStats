function test_suite = test_horzcat(varargin) %#ok<STOUT>
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


initTestSuite;

function testTwoTables %#ok<*DEFNU>

array1 = randi(10, [10 4]);
tab1 = Table(array1);

array2 = randi(10, [10 3]);
tab2 = Table(array2);

res = [tab1 tab2];
assertEqual([10 7], size(res.data));
