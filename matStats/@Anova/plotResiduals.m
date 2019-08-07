function plotResiduals(this, varargin)
%PLOTRESIDUALS  Plot residuals of current Anova
%
%   plotResiduals(ANO)
%
%   Example
%   plotResiduals
%
%   See also
%     residuals, plotCoefficients
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

stats = this.Stats;

% changes current axis or figure if needed
if ishandle(stats)
    type = get(stats, 'type');
    if strcmp(type, 'axes')
        axis(stats);
    elseif strcmp(type, 'figure')
        figure(stats);
    end
    stats = varargin{1};
    varargin(1) = [];
else
    figure;
end

% default style for drawing
if isempty(varargin)
    varargin = {'s'};
end

plot(stats.resid, varargin{:});
hold on;

nr = length(stats.resid);
plot([1 nr], [0 0], 'k');

xlabel('Observations');
ylabel('Residuals');
