function h = correlationCircles(this, varargin)
%CORRELATIONCIRCLES Represent correlation matrix using colored circles
%
%   output = correlationCircles(input)
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     correlationCircles(tab(:,1:4));
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-07-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% number of variables
n = size(this, 2);
rows = n;
cols = n;

% compute the correlation matrix of input array
cc = corrcoef(this);

% initialize th colormap
cmap = jet(256);

cax = gca;

% Create/find BigAx and make it invisible
BigAx = newplot(cax);
fig = ancestor(BigAx, 'figure');
hold_state = ishold(BigAx);
set(BigAx, ...
    'Visible', 'off', ...
    'xlim', [-1 1], ...
    'ylim', [-1 1], ...
    'DataAspectRatio', [1 1 1], ...
    'PlotBoxAspectRatio', [1 1 1], ...
    'color', 'none');

pos = get(BigAx, 'Position');

% size of sub-plots
width   = pos(3) / (rows+1);
height  = pos(4) / (cols+1);
% tmp = min(width, height);
% width = tmp;
% height = tmp;


% 2 percent space between axes
space = .02;
pos(1:2) = pos(1:2) + space * [width height];

% xlim = zeros([rows cols 2]);
% ylim = zeros([rows cols 2]);

BigAxHV = get(BigAx, 'HandleVisibility');
BigAxParent = get(BigAx, 'Parent');

% pre-compute data for circle
t = linspace(0, 2*pi, 100)';
cx = cos(t);
cy = sin(t);

% iterate over all cells
for i = rows:-1:1
    for j = cols:-1:1
        
        axPos = [...
            pos(1) + (j-1+1) * width  ...
            pos(2) + (rows-i-1) * height ...
            width * (1-space) ...
            height * (1-space)];
        
        ax(i,j) = axes(...
            'Position', axPos, ...
            'HandleVisibility', BigAxHV, ...
            'parent', BigAxParent);
        
        indColor = min(floor((cc.data(i,j) + 1) * 128) + 1, 256);
        color = cmap(indColor, :);
        r = abs(cc.data(i, j));
        
        hh(i,j) = fill(cx*r, cy*r, color);
        
        set(ax(i,j), ...
            'xlim', [-1 1], ...
            'ylim', [-1 1], ...
            'DataAspectRatio', [1 1 1], ...
            'xgrid', 'off', ...
            'ygrid', 'off', ...
            'Visible', 'off');
        
%         xlim(i,j,:) = get(ax(i,j), 'xlim');
%         ylim(i,j,:) = get(ax(i,j), 'ylim');
    end
end


set(ax(:), 'xticklabel', '')
set(ax(:), 'yticklabel', '')
set(BigAx, ...
    ... 'XTick', get(ax(rows,1), 'xtick'), ...
    ... 'YTick', get(ax(rows,1), 'ytick'), ...
    'userdata', ax, ...
    'tag', 'PlotMatrixBigAx');
set(ax, 'tag', 'PlotMatrixScatterAx');

% Make BigAx the CurrentAxes
set(fig,'CurrentAx',BigAx)
if ~hold_state,
    set(fig,'NextPlot','replace')
end

% Also set Title and X/YLabel visibility to on and strings to empty
set([get(BigAx,'Title'); get(BigAx,'XLabel'); get(BigAx,'YLabel')], ...
    'String','','Visible','on')

% display labels on the left and on the top of the circle array
for i = 1:n
    set(ax(1,i), 'XAxisLocation', 'Top');
    xlabel(ax(1, i), this.colNames{i}, ...
        'Visible', 'On', 'FontSize', 12, 'Rotation', 45, ...
        'VerticalAlignment', 'Middle', 'HorizontalAlignment', 'Left');
    ylabel(ax(i, 1), this.colNames{i}, ...
        'Visible', 'On', 'FontSize', 12, 'Rotation', 0, ...
        'VerticalAlignment', 'Middle', 'HorizontalAlignment', 'Right');
end

% return handles if needed
if nargout ~= 0
    h = hh;
end


