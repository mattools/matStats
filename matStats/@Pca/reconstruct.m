function res = reconstruct(obj, coords, varargin)
% Create a synthetic data set from its coordinates in loadings space.
%
%   RES = reconstruct(PCA, COORDS)
%   PCA is the result if the Principal Components analysis, and COORDS is
%   a M-by-Q array or Table, where M is the number of observations to
%   reconstruct and Q is the number of principal components.
%   RES is a M-by-N Table, with N columns corresponding to the N columns in
%   the original data table.
%
%
%   Example
%     % Create synthetic individuals from coordinates in loadings space
%     iris = Table.read('fisherIris');
%     irisPca = Pca(iris(:,1:4), 'Scale', false, 'Display', false);
%     figure; scatterPlot(irisPca.Scores, 1, 2);
%     coords = [3.5 0; 0 1.4;-3.5 0];
%     rec = reconstruct(irisPca, coords)
%     rec = 
% 
%         SepalLength    SepalWidth    PetalLength    PetalWidth
%         -----------    ----------    -----------    ----------
%              4.5785        3.3532        0.75965     -0.054679
%              4.9241        2.0351         4.0007         1.305
%              7.1082        2.7615         6.7563        2.4533
%
%   See also
%     Pca, transform
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-07-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

% manage coords given as Table
if isa(coords, 'Table')
    coords = coords.Data;
end

    
% get the size of the various arrays
nRows = size(coords, 1);
nCols = size(obj.Means, 2);
% number of reconstruction components
nComps = size(obj.Loadings, 1); 

% check input
if size(coords, 2) > nComps
    error('MatStats:Pca', ...
        'Too many coordinates (%d), PCA has only %d components', nCoords, nComps);
end

% allocate memort
res = zeros(nRows, nCols);

% iterate over the rows of the result
for iRow = 1:nRows
    % init from PCA vector of means
    resi = obj.Means.Data;
    
    % iterate over the components to reconstruct
    % (allows to specify less components than the total)
    for iComp = 1:min(nComps, size(coords, 2))
        coeff = coords(iRow, iComp);
        resi = resi + coeff * obj.Loadings.Data(:,iComp)' .* obj.Scalings.Data;
    end
    
    res(iRow,:) = resi;
end

% convert to Table
res = Table(res, obj.Means.ColNames, ...
    'Name', 'Reconstructed');
