function varargout = pca(this, varargin)
%PCA Principal components analysis of the data
%
%   Usage
%   SC = pca(TAB);
%   [SC LD] = pca(TAB);
%   [SC LD EV] = pca(TAB);
%
%   Description
%   CO = pca(TAB);
%   Performs Principal components analysis of the data in table and returns
%   the transformed coordinates.
%   
%
%   Example
%   pca
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Parse input arguments

display = true;
scale = false;

while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'display'
            display = varargin{2};
        case 'scale'
            scale = varargin{2};
        otherwise
            error(['Unknown parameter name: ' paramName]);
    end

    varargin(1:2) = [];
end

if ischar(display)
    display = strcmpi(display, 'on');
end


%% Pre-processing

% recenter data (remove mean)
cData = bsxfun(@minus, this.data, mean(this.data, 1));

% optional scaling of data (divide by standard error)
if scale
    sigma   = sqrt(var(cData));
    cData   = cData * diag(1 ./ sigma);
end


%% Computation of Principal components

% computation of covariance matrix
V = cData' * cData;  
V = V / (size(cData, 1) - 1);

% Diagonalisation of the covariance matrix.
[eigenVectors, vl, coord] = svd(V); %#ok<NASGU>

% compute new coordinates from the eigen vectors
coord = cData * eigenVectors;

% compute array of eigen values
eigenValues = zeros(size(this.data, 2), 3);
eigenValues(:, 1) = diag(vl);
eigenValues(:, 2) = 100 * eigenValues(:,1) / sum(eigenValues(:,1));
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
    'rowNames', this.rowNames, 'colNames', varNames, 'name', name);

% Table object for loadings
if ~isempty(this.name)
    name = sprintf('Loadings of %s', this.name);
else
    name = 'Loadings';
end
ld = Table.create(eigenVectors, ...
    'rowNames', this.colNames, 'colNames', varNames, 'name', name);

% Table object for loadings
if ~isempty(this.name)
    name = sprintf('Eigen values of %s', this.name);
else
    name = 'Eigen values';
end
ev = Table.create(eigenValues, ...
    'rowNames', varNames, 'name', name, ...
    'colNames', {'EigenValues', 'Inertia', 'Cumulated'});


%% Display some data

if display
    displayPcaResults(this.name, sc, ld, ev);
end


%% Format output arguments

if nargout == 1
    varargout = {sc};
    
elseif nargout == 3
    varargout = {sc, ld, ev};
end


function displayPcaResults(name, sc, ld, ev)

coord = sc.data;
eigenValues = ev.data;

% distribution of the first 10 eigen values
figure('Name', 'PCA - Eigen Values', 'NumberTitle', 'off');
nx = min(10, size(coord, 2));
plot(1:nx, eigenValues(1:nx, 2));
xlim([1 nx]);
xlabel('Number of components');
ylabel('Inerta (%)');
title([name ' - eigen values'], 'interpreter', 'none');

% individuals in plane PC1-PC2
figure('Name', 'PCA - Comp. 1 and 2', 'NumberTitle', 'off');
%     scatterPlot(sc, 'pc1', 'pc2');
x = coord(:, 1);
y = coord(:, 2);
drawText(x, y, sc.rowNames);
xlabel(sprintf('Principal component 1 (%5.2f)', eigenValues(1, 2)));
ylabel(sprintf('Principal component 2 (%5.2f)', eigenValues(2, 2)));
title(name, 'interpreter', 'none');

% individuals in plane PC3-PC4
figure('Name', 'PCA - Comp. 3 and 4', 'NumberTitle', 'off');
%     scatterPlot(sc, 'pc3', 'pc4');
x = coord(:, 3);
y = coord(:, 4);
drawText(x, y, sc.rowNames);
xlabel(sprintf('Principal component 3 (%5.2f)', eigenValues(3, 2)));
ylabel(sprintf('Principal component 4 (%5.2f)', eigenValues(4, 2)));
title(name, 'interpreter', 'none');


function drawText(x, y, labels)
%DRAWTEXT display text with specific formating
plot(x, y, '.w');
text(x, y, labels, 'color', 'k', 'fontsize', 8);
