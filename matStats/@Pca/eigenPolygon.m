function poly = eigenPolygon(obj, index, coef, varargin)
% Eigen polygon representing variation on a given axis.
%
%   POLY = eigenPolygon(PCA, INDEX, COEF)
%
%   Example
%   eigenPolygon
%
%   See also
%     Pca, eigenCurve
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-12-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% to transform vector to polygon
method = 'packed';

% default result: res = 2 * sqrt(lambda) * loading
if nargin < 3
    coef = 2;
end

% lambda = var(obj.scores(:,index).data);

% compute eigen vector with appropriate coeff
ld = obj.Loadings(:, index).Data';
lambda = obj.EigenValues(index, 1).Data;
values = obj.Means + coef * sqrt(lambda) * ld;

% resulting polygon
poly = rowToPolygon(values, method);
