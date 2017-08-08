function res = residuals(this, varargin)
%RESIDUALS  Returns the residuals of Anova result
%
%   residuals(ANO)
%
%   Example
%   plotResiduals
%
%   See also
%   plotResiduals

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-08-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2015 INRA - Cepia Software Platform.

stats = this.stats;

resids = stats.resid;

res = Table(resids, {'Residuals'});
