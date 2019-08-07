function biplot(this, varargin)
%BIPLOT Biplot of a Principal Component Analysis
%
%   biplot(PCA, CPI, CPJ)
%   biplot(PCA, CPI, CPJ, CPK)
%   biplot(PCA, [CPI CPJ])
%   biplot(PCA, [CPI CPJ CPK])
%
%   Example
%   biplot
%
%   See also
%     scorePlot, loadingPlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-11-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% select two or three coordinates
if isempty(varargin)
    inds = [1 2];
else
    if ~isscalar(varargin{1})
        % keeps the display coordinates given as row vector
        inds = varargin{1};
        
    else
        % keeps the input coordinates given as separate arguments
        narg = 2;
        if length(varargin) > 2 
            var3 = varargin{3};
            if isnumeric(var3) && isscalar(var3)
                narg = 3;
            end
        end
        inds = cell2mat(varargin(1:narg));
    end
end

% calls the native biplot function with appropriate legends
biplot(this.Loadings(:, inds).Data, ...
    'Scores', this.Scores(:, inds).Data,...
    'VarLabels', this.Loadings.RowNames);

grid off;

% create legends
annotateFactorialPlot(this, inds(1), inds(2));
