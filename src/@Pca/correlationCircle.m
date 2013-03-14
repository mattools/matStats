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
    error('Component index should be less than variable number');
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
    correl(:,i) = sqrt(values(i)) * this.loadings(1:nv,i).data;
end

correl = Table.create(correl, ...
    'rowNames', this.loadings.rowNames(1:nv), ...
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

% setup display
hold on;
plot(x, y, '.');
makeCircleAxis;

% create legends
annotateFactorialPlot(this, cp1, cp2);

if nargout > 0
    varargout = {h};
end
