function varargout = scorePlot(varargin)
%SCOREPLOT Plot individuals in a factorial plane
%
%   scorePlot(CDA, I, J)
%
%   scorePlot(CDA)
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

% Extract the axis handle to draw in
[ax varargin] = parseAxisHandle(varargin{:});

% extract calling table
this = varargin{1};
varargin(1) = [];

% get factorial axes
cc1 = 1;
cc2 = 2;
if length(varargin) >= 2 && isnumeric(varargin{1})
    cc1 = varargin{1};
    cc2 = varargin{2};    
    varargin(1:2) = [];
end

% input argument control
nc = size(this.scores, 2);
if cc1 > nc || cc2 > nc
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

% Set up parent figure
hFig = get(ax, 'Parent');
str = sprintf('CDA Scores - CC%d vs CC%d', cc1, cc2);
set(hFig, 'Name', str, 'NumberTitle', 'off');

% setup axis
if ~isempty(varargin)
    set(ax, varargin{:});
end

% score coordinates
x = this.scores(:, cc1);
y = this.scores(:, cc2);
scatterGroup(x, y, this.group);

% display either names or dots
if showNames
    text(x.data, y.data, this.scores.rowNames, ...
    'HorizontalAlignment', 'Center', ...
    'VerticalAlignment', 'Bottom', ...
    'color', 'k', 'fontsize', 8, varargin{:});
end

% create legends
annotateFactorialPlot(this, ax, cc1, cc2);

if nargout > 0
    varargout = {hFig};
end
