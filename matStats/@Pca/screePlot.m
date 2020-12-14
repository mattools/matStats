function varargout = screePlot(obj, varargin)
% Display the scree plot of the PCA result.
%
%   screePlot(PCA)
%   Displays the scree plot of the PCA object in a new figure.
%
%   screePlot(PCA, NC)
%   Chooses the number of components to display. NC must be lower than the
%   number of components of the PCA result.
%
%   H = screePlot(PCA)
%   Returns a handle to the created figure.
%
%   Example
%   screePlot
%     iris = Table.read('fisherIris.txt');
%     resPca = Pca(iris, 'display', 'off');
%     screePlot(resPca, 'FontSize', 14);
%
%   See also
%     Pca, scorePlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2013-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% Number of components to display
nc = 10;
if ~isempty(varargin) 
    var1 = varargin{1};
    if isnumeric(var1) && isscalar(var1)
        nc = var1;
        varargin(1) = [];
    end
end


% extract data
name    = obj.TableName;
coord   = obj.Scores.Data;
values  = obj.EigenValues.Data;

% number of components to display
nc = min(nc, size(coord, 2));

% distribution of the first 10 eigen values
h = figure('Name', 'PCA - Eigen Values', 'NumberTitle', 'off');
if ~isempty(varargin)
    set(gca, varargin{:});
end

% scree plot
bar(1:nc, values(1:nc, 2));
% hold on;
% plot(1:nx, values(1:nx, 3), 'color', 'r', 'linewidth', 2);

% setup graph
xlim([0 nc+1]);

% annotations
xlabel('Number of components');
ylabel('Inertia (%)');
title([name ' - eigen values'], 'interpreter', 'none');

% eventually returns handle to graphic handle
if nargout > 0
    varargout = {h};
end
