function influencePlot(this)
%INFLUENCEPLOT  One-line description here, please.
%
%   output = influencePlot(input)
%
%   Example
%   influencePlot
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

n = size(this.scores, 1);
% p = size(this.scores, 2);


% xi = sqrt(sum(this.scores.data .^ 2, 2));
% xi = max(abs(this.scores.data), [], 2);
xi = abs(this.scores.data(:,1));
yi = min(abs(this.scores.data), [], 2);


drawText(xi, yi, this.scores.rowNames);
hold on;
plot(xi, yi, 'k.');
