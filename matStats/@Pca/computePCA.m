function computePCA(obj, data)
% Compute scores and loadings of PCA from a data table and PCA settings.
%
%   This is a private function, that updates properties of the calling PCA
%   object.
%
%   Usage:
%   computePCA(OBJ, TABLE)
%   OBJ is the Pca instance. TABLE is an instance of Table class. 
%
%   Example
%   computePCA
%
%   See also
%    Pca
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

%% Pre-processing

% keep name of original data table
obj.TableName = data.Name;

% create table containing mean data
obj.Means = Table(mean(data.Data, 1), data.ColNames, 'Name', 'Means');

% recenter data (remove mean)
cData = bsxfun(@minus, double(data.Data), obj.Means.Data);

% optional scaling of data (divide each column by standard deviation)
if obj.Scaled
    sigmas   = sqrt(var(cData));
    sigmas(sigmas < 1e-10) = 1;
    cData   = cData * diag(1 ./ sigmas);
else
    sigmas = ones(1, size(cData, 2));
end
% convert to data table
obj.Scalings = Table(sigmas, data.ColNames, 'Name', 'Sigmas');


%% Computation of Principal components

% computation of covariance matrix

transpose = false;
if size(cData, 1) < size(cData, 2) && size(cData, 2) > 50
    % If data table has large number of variables, computes the covariance
    % matrix on the transposed array.
    % Result V has dimension nind x nind
    transpose = true;
    V = cData * cData';
    
else
    % V has dimension nvar * nvar
    V = cData' * cData;  
end

% divides by the number of rows to have a covariance
V = V / (size(cData, 1) - 1);


% Diagonalisation of the covariance matrix.
% * eigenVectors: basis transform matrix
% * vl: eigen values diagonal matrix
% * coord: not used
[eigenVectors, vl, coord] = svd(V);

% In case the input table was transposed, eigen vectors need to be
% recomputed from the coord array
if transpose
    eigenVectors = cData' * coord;
    
    % Normalisation of eigen vectors, such that eigenVectors * eigenVectors
    % corresponds to identity matrix
    for i = 1:size(eigenVectors, 2)
        eigenVectors(:,i) = eigenVectors(:,i) / sqrt(sum(eigenVectors(:,i) .^ 2));
    end
end

% compute new coordinates from the eigen vectors
coord = cData * eigenVectors;

% compute array of eigen values
vl = diag(vl);
eigenValues = zeros(length(vl), 3);
eigenValues(:, 1) = vl;                         % eigen values
eigenValues(:, 2) = 100 * vl / sum(vl);         % inertia
eigenValues(:, 3) = cumsum(eigenValues(:,2));   % cumulated inertia


%% Create results axes

% name of new components axis elements
nCols = size(data.Data, 2);
if transpose
    nCols = size(data.Data, 1);
end
varNames = strtrim(cellstr(num2str((1:nCols)', 'pc%d')))';


%% Create result data tables

% Table object for new coordinates ("scores")
if ~isempty(data.Name)
    name = sprintf('Scores of %s', data.Name);
else
    name = 'Scores';
end
obj.Scores = Table.create(coord, ...
    'RowNames', data.RowNames, ...
    'ColNames', varNames, ...
    'Name', name);

% Table object for loadings
if ~isempty(data.Name)
    name = sprintf('Loadings of %s', data.Name);
else
    name = 'Loadings';
end
obj.Loadings = Table.create(eigenVectors, ...
    'RowNames', data.ColNames, ...
    'ColNames', varNames, ...
    'Name', name);

% Table object for eigen values
if ~isempty(data.Name)
    name = sprintf('Eigen values of %s', data.Name);
else
    name = 'Eigen values';
end
obj.EigenValues = Table.create(eigenValues, ...
    'RowNames', varNames', ...
    'Name', name, ...
    'ColNames', {'EigenValues', 'Inertia', 'Cumulated'});



