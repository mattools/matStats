function varargout = kmeans(this, k, varargin)
%KMEANS K-means clustering of the data table
%
%   GROUPS = kmeans(TAB, K)
%   Computes homogenenous groups in the input data table using the k-means
%   algorithm. 
%   Simply a wrapper to the 'kmeans' function from statistics toolbox.
%
%
%   Example
%     iris = Table.read('fisherIris');
%     res = kmeans(iris(:,1:4), 3);
%     scatterGroup(iris(:,3), iris(:,4), res);
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-11-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% call the kmeans function with adequate number of output arguments
varargout = cell(max(nargout, 1), 1);
[varargout{:}] = kmeans(this.data, k, varargin{:});

% format the first ouput table
colNames = {sprintf('kmeans%d', k)};
varargout{1} = Table(varargout{1}, colNames, this.rowNames);

% if no output is asked, display a map of the result
if nargout == 0
    if size(this, 2) > 1
        this.scatterGroup(1, 2, varargout{1}, 1);
    end
    varargout = {};
end
