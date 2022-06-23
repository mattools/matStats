%IRIS_HISTOGRAM  One-line description here, please.
%
%   output = iris_histogram(input)
%
%   Example
%   iris_histogram
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-22,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

iris = Table.read('fisherIris');

figure;
histogram(iris('PetalLength'), 30);

print(gcf, 'iris_histogram_n30.png', '-dpng');