%DEMOPAIRPLOT_IRIS  One-line description here, please.
%
%   output = demoPairPlot_iris(input)
%
%   Example
%   demoPairPlot_iris
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
figure; pairPlot(iris(:,1:4), iris(:,5));
print(gcf, 'iris_pairPlot_bySpecies.png', '-dpng');