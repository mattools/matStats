function tests = test_bivariateHistogram
% Test suite for the file bivariateHistogram.
%
%   Test suite for the file bivariateHistogram
%
%   Example
%   test_bivariateHistogram
%
%   See also
%     bivariateHistogram

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-28,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris');

counts = bivariateHistogram(iris(:,1), iris(:,2), [20 20]);

assertEqual(testCase, size(counts), [20 20]);


