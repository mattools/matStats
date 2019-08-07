function ht = drawText(ax, x, y, labels, varargin)
%DRAWTEXT Display text with specific formating
%
%   drawText(AX, X, Y, LABELS)
%   HT = drawText(AX, X, Y, LABELS)
%
%   Example
%   drawText
%
%   See also
%     drawCircleAxis

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% first draw points 
plot(ax, x, y, '.k');

% add labels
axes(ax);
ht = text(x, y, labels, ...
    'HorizontalAlignment', 'Center', ...
    'VerticalAlignment', 'Bottom', ...
    'color', 'k', 'fontsize', 8, varargin{:});
