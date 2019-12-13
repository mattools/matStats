%Performs KMeans on iris data set after PCA dimensionality reduction.
%
%   output = demo_kmeans_iris(input)
%
%   Example
%   demo_kmeans_iris
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-12-12,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2019 INRA - Cepia Software Platform.

% read data table
iris = Table.read('fisherIris.txt');

% separate numerical and categorical data
data = iris(:, 1:4);
species = iris('Species');

% Apply k-means, and returns both classes and centroid
[k, centroids] = kmeans(data, 3);

% display result
figure; set(gca, 'fontsize', 14); hold on;
hg = scatterGroup(data(:,3), data(:,4), k);
hc = scatter(centroids(:,3), centroids(:,4), 'k*');
legend([hg hc], {'Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids'}, 'Location', 'NorthWest');

% compare with original segmentation
figure; set(gca, 'fontsize', 14);
scatterGroup(data(:,3), data(:,4), species);

