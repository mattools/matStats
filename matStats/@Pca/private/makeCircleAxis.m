function [hc, hl1, hl2] = makeCircleAxis(varargin)
%MAKECIRCLEAXIS  Draw a circle and format display
%
%   output = makeCircleAxis(input)
%
%   Example
%   makeCircleAxis
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


if isempty(varargin)
    ax = varargin{1};
else
    ax = gca;
end

holdState = ishold(ax);
hold(ax, 'on');

x = linspace(0, 2*pi, 200);
hc = plot(cos(x), sin(x), 'k');

axis square;
hl1 = plot([-1 1], [0 0], ':k');
hl2 = plot([0 0 ], [-1 1], ':k');

axis([-1.1 1.1 -1.1 1.1]);

if ~holdState
    hold(ax, 'off');
end
