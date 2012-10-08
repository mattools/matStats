function varargout = scorePlot(this, cp1, cp2, varargin)
%SCOREPLOT Plot individuals in a factorial plane
%
%   scorePlot(PCA, I, J)
%
%   scorePlot(PCA)
%   Assumes I = 1 and J = 2.
%
%   Example
%   scorePlot
%
%   See also
%   loadingPlot, correlationCircle
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if nargin < 3 || ischar(cp1)
    % update option list
    if ischar(cp1)
        varargin = [{cp1, cp2} varargin];
    end
    
    % choose default axis
    cp1 = 1;
    cp2 = 2;    
end

% input argument control
nc = size(this.scores, 2);
if cp1 > nc || cp2 > nc
    error('Component number should be less than variable number');
end

% extract display options
showNames = true;
for i = 1:2:(length(varargin)-1)
    if strcmpi('showNames', varargin{i})
        showNames = varargin{i+1};
        varargin(i:i+1) = [];
        break;
    end
end

% create new figure
str = sprintf('PCA - Comp. %d and %d', cp1, cp2);
h = figure('Name', str, 'NumberTitle', 'off');
if ~isempty(varargin)
    set(gca, varargin{:});
end

% score coordinates
x = this.scores(:, cp1).data;
y = this.scores(:, cp2).data;

% display either names or dots
if showNames
    drawText(x, y, this.scores.rowNames);
else
    plot(x, y, '.k');
end

% create legends
annotateFactorialPlot(this, cp1, cp2);

if nargout > 0
    varargout = {h};
end
