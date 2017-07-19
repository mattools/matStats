function varargout = influencePlot(this, varargin)
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


xi = sqrt(sum(this.scores.data .^ 2, 2));
% xi = max(abs(this.scores.data), [], 2);
% xi = abs(this.scores.data(:,1));
yi = min(abs(this.scores.data), [], 2);

% prepare figure
figure;
if ~isempty(varargin)
    set(gca, varargin{:});
end

% influence plot
plot(xi, yi, 'k.');
hold on;
if n < 200
    drawText(xi, yi, this.scores.rowNames);
end

% annotate graph
xlabel('Distance to origin');
ylabel('Distance to axis');
title([this.tableName ' - Influence plot']);

% return graphic handle if needed
if nargout > 0
    varargout = {h};
end
