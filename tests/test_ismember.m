function tests = test_ismember(varargin)
%TEST_ISMEMBER  Test case for the file ismember
%
%   Test case for the file ismember

%   Example
%   test_ismember
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-12-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);


function test_MagicSquare(testCase) %#ok<*DEFNU>
% Test call of function without argument
tab = Table(magic(3));
res = ismember(tab, [1 2 3]);
exp = logical([0 1 0; 1 0 0;0 0 1]);

assertEqual(testCase, exp, res.Data);

