function poly = eigenPolygon(this, index, coef, varargin)
%EIGENPOLYGON eigen polygon representing variation on a given axis
%
%   POLY = eigenPolygon(PCA, INDEX, COEF)
%
%   Example
%   eigenPolygon
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-12-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% to transform vector to polygon
method = 'packed';

% default result: res = 2 * sqrt(lambda) * loading
if nargin < 3
    coef = 2;
end

% lambda = var(this.scores(:,index).data);

% compute eigen vector with appropriate coeff
ld = this.loadings(:, index).data';
lambda = this.eigenValues(index, 1).data;
values = this.means + coef * sqrt(lambda) * ld;

% resulting polygon
poly = rowToPolygon(values, method);
