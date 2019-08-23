function curve = eigenCurve(obj, index, coef, varargin)
% Eigen curve representing variation on a given axis.
%
%   CURVE = eigenCurve(PCA, INDEX, COEF)
%
%   Example
%   eigenCurve
%
%   See also
%     eigenPolygon
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-12-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% default result: res = 2 * sqrt(lambda) * loading
if nargin < 3
    coef = 2;
end

% compute eigen vector with appropriate coeff
ld = obj.Loadings(:, index).Data';
lambda = obj.EigenValues(index, 1).Data;
curve = obj.Means + coef * sqrt(lambda) * ld;

