function res = transform(obj, data)
% Transform new data to canonical space.
%
%   RES = transform(PCA, DATA)
%
%   Example
%     % Read the iris data set
%     iris = Table.read('fisherIris.txt');
%     % Compute PCA on a reduced data set
%     resPca = Pca(iris(1:2:end,1:4), 'Display', 'Off');
%     figure; scorePlot(resPca, 1, 2);
%     hold on;
%     % Apply transform on the whole data set. Original individuals appear
%     % both as dot and as circles.
%     scores = transform(resPca, iris(:,1:4));
%     plot(scores.Data(:,1), scores.Data(:,2), 'bo')
%
%   See also
%     Pca, scorePlot, reconstruct
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-11-03,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

% check dimensionality
if size(data, 2) ~= size(obj.Loadings, 1)
    error('Data should have same number of variables as original analysis.');
end

% compute new coordinates
coords = bsxfun(@minus, data.Data, obj.Means);
coords = bsxfun(@mrdivide, coords, obj.Scalings);
newCoords = coords * obj.Loadings.Data;

% name of new columns
nDims = size(obj.Loadings, 2);
varNames = strtrim(cellstr(num2str((1:nDims)', 'pc%d')));

% compute new name
name = 'Coords';
if ~isempty(obj.TableName)
    name = sprintf('Coords of %s', obj.TableName);
end

% Table object for canonical coordinates
res = Table.create(newCoords, ...
    'RowNames', data.RowNames, ...
    'ColNames', varNames, ...
    'Name', name);
