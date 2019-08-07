function varargout = plotmatrix(this, varargin)
%PLOTMATRIX Overload plotmatrix function to display column names
%
%   plotmatrix(TAB)
%
%   [H, AX, hBigAx, P] = plotmatrix(TAB)
%
%   Example
%     % Display histograms and joint histograms of Iris values
%     iris = Table.read('fisherIris');
%     plotmatrix(iris(:, 1:4));
%
%   See also
%     histogram
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% call classical plotmatrix function
[H, AX, BigAx, P, Pax] = plotmatrix(this.Data);

% also display column names as labels
nCols = size(this, 2);
for i = 1:nCols
    xlabel(AX(nCols, i), this.ColNames{i}, ...
        'Visible', 'On', 'FontSize', 12);
    ylabel(AX(i, 1), this.ColNames{i}, ...
        'Visible', 'On', 'FontSize', 12, 'Rotation', 0, ...
        'VerticalAlignment', 'Middle', 'HorizontalAlignment', 'Right');
end


% Update histogram data
nRows = size(this, 1);
nBins = min(nRows / 10, 100);
% props = {'Vertices', 'Faces', 'FaceVertexCData'};
for i = 1:nCols
    hf = figure;
    histogram(this.Data(:, i), nBins);
    
%     hh = get(gca, 'Children');
%     set(P(i), props, get(hh, props));
    close(hf);
end

% Update label font size
for i = 1:nCols
    set(get(AX(nCols, i), 'XLabel'), 'FontSize', 12)
    set(get(AX(i, 1), 'YLabel'), 'FontSize', 12)
end

% Update axes tick labels
for i = 1:(nCols * nCols)
    set(AX(i), 'FontSize', 10);
end


if nargout == 1
    varargout = {H};
elseif nargout > 1
    varargout = {H, AX, BigAx, P, Pax};
end
