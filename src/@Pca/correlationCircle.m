function varargout = correlationCircle(this, cp1, cp2, varargin)
%CORRELATIONCIRCLE Plot correlation circle in a factorial plane
%
%   output = correlationCircle(input)
%
%   Example
%   correlationCircle
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


if nargin < 3 || ischar(cp1)
    cp1 = 1;
    cp2 = 2;
end

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
str = sprintf('PCA Correlation Circle - Comp. %d and %d', cp1, cp2);
h = figure('Name', str, 'NumberTitle', 'off');
if ~isempty(varargin)
    set(gca, varargin{:});
end

name = this.tableName;
values = this.eigenValues.data;

% Create the correlation table
nv = size(this.scores, 2);
correl = zeros(nv, nv);
for i = 1:nv
    correl(:,i) = sqrt(values(i)) * this.loadings(:,i).data;
end

correl = Table.create(correl, ...
    'rowNames', this.loadings.rowNames, ...
    'name', name, ...
    'colNames', this.loadings.colNames);


% score coordinates
x = correl(:, cp1).data;
y = correl(:, cp2).data;

% display either names or dots
if showNames
    drawText(x, y, correl.rowNames, ...
        'HorizontalAlignment', 'Center', ...
        'VerticalAlignment', 'Bottom');
end

hold on;
plot(x, y, '.');
makeCircleAxis;

% % create legends
% vl1 = this.eigenValues(cp1, 2).data;
% vl2 = this.eigenValues(cp2, 2).data;
% xlabel(sprintf('Principal component %d (%5.2f %%)', cp1, vl1));
% ylabel(sprintf('Principal component %d (%5.2f %%)', cp2, vl2));
% title(this.tableName, 'interpreter', 'none');
annotateFactorialPlot(this, cp1, cp2);

if nargout > 0
    varargout = {h};
end
