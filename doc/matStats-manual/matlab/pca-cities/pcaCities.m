%PCACITIES  One-line description here, please.
%
%   output = pcaCities(input)
%
%   Example
%   pcaCities
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-06-16,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% load data
load cities.mat

% format to a data table
colNames = strtrim(cellstr(categories))';
rowNames = strtrim(cellstr(names));
cities = Table(ratings, colNames, rowNames);

resPca = Pca(cities, 'scale', true, 'display', 'off');


