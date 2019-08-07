function res = residuals(this, varargin)
%RESIDUALS  Returns the residuals of Anova result
%
%   RES = residuals(ANOVA)
%   Returns the residuals of the ANOVA object within a new Table instance.
%
%   Example
%   plotResiduals
%
%   See also
%     plotResiduals
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2015-08-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2015 INRA - Cepia Software Platform.

stats = this.Stats;

resids = stats.resid;

res = Table(resids, {'Residuals'});
