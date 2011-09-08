function varargout = plotmatrix(this, varargin)
%PLOTMATRIX Overload plotmatrix function to display column names
%
%   plotmatrix(TAB)
%
%   [H AX hBigAx P] = plotmatrix(TAB)
%
%   Example
%   plotmatrix
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% call classical plotmatrix function
[H AX BigAx P Pax] = plotmatrix(this.data);

% also display column names as labels
nCols = size(this, 2);
for i = 1:nCols
    xlabel(AX(nCols, i), this.colNames{i});
end

if nargout > 0
    varargout = {H, AX, BigAx, P, Pax};
end
