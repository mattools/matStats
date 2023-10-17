function tests = test_convertCharArray
% Test suite for the file convertCharArray.
%
%   Test suite for the file convertCharArray
%
%   Example
%   test_convertCharArray
%
%   See also
%     convertCharArray

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2023-10-17,    using Matlab 9.14.0.2206163 (R2023a)
% Copyright 2023 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_iris_species(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = load('fisheriris');
species = Table.convertCharArray(data.species, 'Species');

assertTrue(testCase, isa(species, 'Table'));
assertEqual(testCase, size(species), [150 1]);
assertEqual(testCase, length(species.Levels{1}), 3);
