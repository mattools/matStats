%NMF_IRIS  One-line description here, please.
%
%   output = nmf_iris(input)
%
%   Example
%   nmf_iris
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
[W, H] = nmf(iris(:,1:4), 2);
% use Matlab 'biplot' function to represent the results
biplot(H.Data', 'Scores', W.Data, 'varLabels', H.ColNames);
axis equal; axis([0 1.2 0 1.0]);

print(gcf, 'nmf_iris_biplot.png', '-dpng');
