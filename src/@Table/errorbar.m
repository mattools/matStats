function varargout = errorbar(varargin)
%ERRORBAR Overload the errorbar function to manage data tables
%
%   errorbar(Y, E)
%   errorbar(X, Y, E)
%   errorbar(X, Y, L, U)
%   errorbar(..., LineSpec)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     means = groupStats(iris('PetalLength'), iris('Species'), @mean);
%     stds = groupStats(iris('PetalLength'), iris('Species'), @std);
%     errorbar(1:3, means, 2*stds, 'o');
%     xlim([0 4]);
%     set(gca, 'xtick', 1:3);
%     set(gca, 'xtickLabel', iris.levels{5});
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% convert each table into simple array
for i = 1:length(varargin)
    var = varargin{i};
    if isa(var, 'Table')
        varargin{i} = var.data;
    end
end

% call parent function
h = errorbar(varargin{:});

% process output
if nargout > 0
    varargout = {h};
end
