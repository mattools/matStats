function [means sc ld ev] = computePCA(this, scale)
%COMPUTEPCA  Compute PCA on input data table
%
%   output = computePCA(input)
%
%   Example
%   computePCA
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

%% Pre-processing

% recenter data (remove mean)
means = mean(this.data, 1);
cData = bsxfun(@minus, this.data, means);

% optional scaling of data (divide by standard deviation)
if scale
    sigma   = sqrt(var(cData));
    cData   = cData * diag(1 ./ sigma);
end


%% Computation of Principal components

% computation of covariance matrix
V = cData' * cData;  
V = V / (size(cData, 1) - 1);

% Diagonalisation of the covariance matrix.
% * eigenVectors: basis transform matrix
% * vl: eigen values diagonal matrix
% * coord: not used
[eigenVectors, vl, coord] = svd(V); %#ok<NASGU>

% compute new coordinates from the eigen vectors
coord = cData * eigenVectors;

% compute array of eigen values
vl = diag(vl);
eigenValues = zeros(length(vl), 3);
eigenValues(:, 1) = vl;
eigenValues(:, 2) = 100 * vl / sum(vl);
eigenValues(:, 3) = cumsum(eigenValues(:,2));


%% Create result data tables

% name of new columns
varNames = strtrim(cellstr(num2str((1:size(this.data, 2))', 'pc%d')));

% Table object for new coordinates
if ~isempty(this.name)
    name = sprintf('Scores of %s', this.name);
else
    name = 'Scores';
end
sc = Table.create(coord, ...
    'rowNames', this.rowNames, ...
    'colNames', varNames, ...
    'name', name);

% Table object for loadings
if ~isempty(this.name)
    name = sprintf('Loadings of %s', this.name);
else
    name = 'Loadings';
end
ld = Table.create(eigenVectors, ...
    'rowNames', this.colNames, ...
    'colNames', varNames, ...
    'name', name);

% Table object for eigen values
if ~isempty(this.name)
    name = sprintf('Eigen values of %s', this.name);
else
    name = 'Eigen values';
end
ev = Table.create(eigenValues, ...
    'rowNames', varNames, ...
    'name', name, ...
    'colNames', {'EigenValues', 'Inertia', 'Cumulated'});



