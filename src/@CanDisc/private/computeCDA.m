function [canon eigenVectors eigenValues stats] = computeCDA(tab, group)
%CDA Canonical Discriminant analysis
%
%   CAN = cda(DATA, GROUP)
%
%   Example
%   
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-07-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Init

% size of data table
data = tab.data;
nInds = size(data, 1);
nVars = size(data, 2);

% group number
[uniGroups tmp groupIndices] = unique(group.data); %#ok<ASGLU>
nGroups = length(uniGroups);

% recenter data
data = bsxfun(@minus, data, mean(data));

% dimension maximum de l'hyperplan factoriel 
% (ne tient pas compte des groupes vides, manova1 le fait)
% nDimMax = min(nGroups-1, nVars);


%% Calcul de la matrice SCE (Somme des carres des ecarts), ou SSD

% somme des carres des ecarts (totale)
ssd_t = data' * data;
var_t = ssd_t / nInds;

% initialise les variable pour les groups
groupCounts = zeros(nGroups, 1);
groupMeans = zeros(nGroups, nVars);

% somme des carres du "modele" (between groups)
ssd_b = zeros(nVars, nVars);

% somme des carres residuelle (Within groups)
ssd_w = zeros(nVars, nVars);

% Mise a jour des matrices en iterant sur les groupes
for i = 1:nGroups
    inds = groupIndices == i;
    groupCounts(i) = sum(inds);

    % moyenne du groupe
    mu_i = mean(data(inds, :));
    groupMeans(i,:) = mu_i;

    ssd_b = ssd_b + (mu_i' * mu_i) * groupCounts(i);
    
    % les donnees du groupe centree sur la moyenne du groupe
    gdata = bsxfun(@minus, data(inds,:), mu_i);
    
    % on actualise la somme des carres residuelle
    ssd_w = ssd_w + gdata' * gdata;
end

% on calcule les matrices de variance covariance en divisant par le nombre
% d'observations
var_b = ssd_b / nInds;
var_w = ssd_w / nInds;


%% Calcul des vecteurs propres

% utilise eig
% (la fonction manova1 utilise une version plus complexe)
% [v, eigenValues] = eigs(ssd_b, ssd_t);
% [v, eigenValues] = eigs(var_b, var_t);
[v, ev] = eig(var_b, var_w);
ev = diag(ev);

% on classe dans l'ordre decroissant des valeurs propres
[ev order] = sort(ev, 'descend');
v = v(:, order);

% Normalisation of eigenVectors to have rotation matrix
for i = 1:nVars
    n = norm(v(:,i));
    v(:,i) = v(:,i) / n;  
end

%% Create Result Tables

% name of new columns
nCols = size(tab.data, 2);
varNames = strtrim(cellstr(num2str((1:nCols)', 'cc%d')));

% Table object for canonical coordinates
if ~isempty(tab.name)
    name = sprintf('Can. Coords of %s', tab.name);
else
    name = 'Can. Coords';
end
canon = Table.create(data * v, ...
    'rowNames', tab.rowNames, ...
    'colNames', varNames, ...
    'name', name);

% Table object for eigen vectors
if ~isempty(tab.name)
    name = sprintf('Loadings of %s', tab.name);
else
    name = 'Loadings';
end
eigenVectors = Table.create(v, ...
    'rowNames', tab.colNames, ...
    'colNames', varNames, ...
    'name', name);

% compute array of eigen values
eigenValues = zeros(length(ev), 3);
eigenValues(:, 1) = ev;                         % eigen values
eigenValues(:, 2) = 100 * ev / sum(ev);         % inertia
eigenValues(:, 3) = cumsum(eigenValues(:,2));   % cumulated inertia

% Table object for eigen values
if ~isempty(tab.name)
    name = sprintf('Eigen values of %s', tab.name);
else
    name = 'Eigen values';
end
eigenValues = Table.create(eigenValues, ...
    'rowNames', varNames, ...
    'name', name, ...
    'colNames', {'EigenValues', 'Inertia', 'Cumulated'});


%% Format outputs
    
if nargout > 3
    stats.W = var_w;
    stats.B = var_b;
    stats.T = var_t;
    
    stats.eigenval = eigenValues;
    stats.eigenvec = v;
    
    stats.canon = canon;
    
    % correlation coefficients (1 row per variable, 1 column per canonical
    % variable).
    stats.corrT = corr(data, canon.data);
    stats.corrB = corr(groupMeans, groupMeans * v);
    resid = data - groupMeans(groupIndices, :);
    stats.corrW = corr(resid, resid * v);
end
