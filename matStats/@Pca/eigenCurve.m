function curve = eigenCurve(this, index, coef, varargin)
%EIGENCURVE Eigen curve representing variation on a given axis
%
%   CURVE = eigenCurve(PCA, INDEX, COEF)
%
%   Example
%   eigenCurve
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-12-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% default result: res = 2 * sqrt(lambda) * loading
if nargin < 3
    coef = 2;
end

% compute eigen vector with appropriate coeff
ld = this.loadings(:, index).data';
lambda = this.eigenValues(index, 1).data;
curve = this.means + coef * sqrt(lambda) * ld;

