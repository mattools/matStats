function tests = test_Anova
% Test suite for the file Anova.
%
%   Test suite for the file Anova
%
%   Example
%   test_Anova
%
%   See also
%     Anova

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-03,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

iris = Table.read('fisherIris');
petalLength = iris('PetalLength');
species = iris('Species');

res = Anova(petalLength, species, 'Display', false);

assertTrue(testCase, isa(res, 'Anova'));
