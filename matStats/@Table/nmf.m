function [w, h, d] = nmf(obj, nc, varargin)
% Non-negative matrix factorization of a data table.
%
%   [W, H] = nmf(TAB, NC)
%   Performs non-negative matrix factorization of the data stored in the
%   TAB Table, using NC components. The methods is simply a wrapper to the
%   "nnmf" function from the statistics toolbox.
% 
%   [W, H] = nmf(TAB, NC, NAME, VALUE)
%   Specifies additional parameters that are transmitted to the nnmf
%   function.
%
%   [W, H, D] = nmf(...)
%   Also returns the root-mean-squared residual D.
%
%   Example
%     % Compute a two-rank approximation of the four measurements in the
%     % iris dataset.
%     iris = Table.read('fisherIris');
%     [W, H] = nmf(iris(:,1:4), 2);
%     % use Matlab 'biplot' function to represent the results
%     biplot(H.Data', 'Scores', W.Data, 'varLabels', H.ColNames);
%     axis equal; axis([0 1.2 0 1.0]);
%
%   See also
%     Pca, nnmf
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-10-19,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

% Call to the Matlab method
[w, h, d] = nnmf(obj.Data, nc, varargin{:});

% Creates the axis for describing the components
names = cellstr(num2str((1:nc)', 'Comp.%02d'))';

% wrap the "scores" matrix
w = Table(w, names, obj.RowNames);

% wrap the "loadings" matrix
h = Table(h, obj.ColNames, names);


