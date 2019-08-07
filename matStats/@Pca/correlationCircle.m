function varargout = correlationCircle(varargin)
%CORRELATIONCIRCLE Plot correlation circle in a factorial plane
%
%   output = correlationCircle(input)
%
%   Example
%   correlationCircle
%
%   See also
%     loadingPlot, scorePlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

% extract calling table
this = varargin{1};
varargin(1) = [];

% get factorial axes
cp1 = 1;
cp2 = 2;
if length(varargin) >= 2 && isnumeric(varargin{1})
    cp1 = varargin{1};
    cp2 = varargin{2};    
    varargin(1:2) = [];
end


nc = size(this.Scores, 2);
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


% Set up parent figure
hFig = get(ax, 'Parent');
str = sprintf('PCA Correlation Circle - CP%d vs CP%d', cp1, cp2);
set(hFig, 'Name', str, 'NumberTitle', 'off');

% Set up axis
cla(ax);
if ~isempty(varargin)
    set(ax, varargin{:});
end

name = this.TableName;
values = this.EigenValues.Data;

% Create the correlation matrix
nv = size(this.Scores, 2);
correl = zeros(nv, nv);
for i = 1:nv
    correl(:,i) = sqrt(values(i)) * this.Loadings(1:nv,i).Data;
end

% create Table instance
correl = Table.create(correl, ...
    'RowNames', this.Loadings.RowNames(1:nv), ...
    'Name', name, ...
    'ColNames', this.Loadings.ColNames);

% score coordinates
x = correl(:, cp1).Data;
y = correl(:, cp2).Data;

% display either names or dots
if showNames
    drawText(ax, x, y, correl.RowNames, ...
        'HorizontalAlignment', 'Center', ...
        'VerticalAlignment', 'Bottom');
end

% setup display
hold on;
plot(ax, x, y, '.');
axes(ax); 
makeCircleAxis(ax);

% create legends
annotateFactorialPlot(this, ax, cp1, cp2);

if nargout > 0
    varargout = {hFig};
end
