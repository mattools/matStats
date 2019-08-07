function varargout = influencePlot(this, varargin)
%INFLUENCEPLOT  One-line description here, please.
%
%   output = influencePlot(input)
%
%   Example
%   influencePlot
%
%   See also
%     scorePlot, loadingPlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-10-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

n = size(this.Scores, 1);

xi = sqrt(sum(this.Scores.Data .^ 2, 2));
yi = min(abs(this.Scores.Data), [], 2);

% prepare figure
figure;
if ~isempty(varargin)
    set(gca, varargin{:});
end

% influence plot
plot(xi, yi, 'k.');
hold on;
if n < 200
    drawText(xi, yi, this.Scores.RowNames);
end

% annotate graph
xlabel('Distance to origin');
ylabel('Distance to axis');
title([this.TableName ' - Influence plot']);

% return graphic handle if needed
if nargout > 0
    varargout = {h};
end
