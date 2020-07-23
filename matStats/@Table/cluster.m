function inds = cluster(obj, varargin)
% Compute cluster indices in data using Hierarchical clustering.
%
%   INDS = cluster(TAB, NCLUST)
%   Simple wrapper for the 'clusterdata' function from the Statistics
%   toolbox;
%
%   Example
%     % Compute clustering on Iris data
%     iris = Table.read('fisherIris.txt');
%     inds = cluster(iris(:, 1:4), 3);
%     % Display confusion matrix with original labeling
%     confusion = crossTable(iris('Species'), inds)
%     confusion = 
%                       1     2     3
%                       -     -     -
%     Setosa            0     0    50
%     Versicolor        0    50     0
%     Virginica         2    48     0
%
%   See also
%     clusterdata, kmeans, crossTable
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-07-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

inds = clusterdata(obj.Data, varargin{:});

inds = Table(inds, 'Parent', obj);
inds.Axes{2} = table.axis.CategoricalAxis('HCA', {'ClassIndex'});
