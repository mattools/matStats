function ht = drawText(x, y, labels, varargin)
%DRAWTEXT display text with specific formating
%
%   drawText(X, Y, LABELS)
%   HT = drawText(X, Y, LABELS)
%
%   Example
%   drawText
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

plot(x, y, '.w');
ht = text(x, y, labels, ...
    'HorizontalAlignment', 'Center', ...
    'VerticalAlignment', 'Bottom', ...
    'color', 'k', 'fontsize', 8, varargin{:});
