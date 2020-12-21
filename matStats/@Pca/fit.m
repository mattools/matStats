function fit(obj, data, varargin)
% Initialize loadings of a PCA object.
%
%   fit(PCA, DATA)
%
%   Example
%     % Load the data
%     iris = Table.read('fisherIris.txt');
%     irisData = iris(:,1:4);
%     % Create PCA with default settings
%     resPca = Pca();
%     % Initialize with iris data
%     resPca.fit(irisData);
%
%   See also
%     Pca, transform
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


%% Parse input arguments

% if first argument is a table or an array, use it as data.
if isnumeric(data)
    data = Table(var1);
end

% ensure data table has a valid name
if isempty(data.Name)
    data.Name = inputname(1);
end

% Intialize PCA results
computePCA(obj, data);
