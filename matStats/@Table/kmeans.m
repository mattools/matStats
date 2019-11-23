function varargout = kmeans(obj, k, varargin)
%KMEANS K-means clustering of the data table.
%
%   GROUPS = kmeans(TAB, K)
%   Computes homogenenous groups in the input data table using the k-means
%   algorithm. 
%   Simply a wrapper to the 'kmeans' function from the statistics toolbox.
%
%
%   Example
%     iris = Table.read('fisherIris');
%     res = kmeans(iris(:,1:4), 3);
%     scatterGroup(iris(:,3), iris(:,4), res);
%
%   See also
%     scatterGroup, aggregate
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-11-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Input checks

% check argument number
if nargin < 2
    error('Need to specify class number');
end

% check presence of stats toolbox
if isempty(strfind(path, fullfile('toolbox', 'stats')))
    error('Requires the statistics toolbox');
end

% pre-process input arguments to transform to double when required
for i = 1:length(varargin)
    if isa(varargin{i}, 'Table')
        varargin{i} = varargin{i}.Data;
    end
end

% get table name
baseName = obj.Name;
if isempty(baseName)
    baseName = 'table';
end
    

%% Compute k-means

% call the kmeans function with adequate number of output arguments
varargout = cell(max(nargout, 1), 1);
[varargout{:}] = kmeans(obj.Data, k, varargin{:});


%% Encapsulate results in tables

% compute name of the groups/classes
groupNames = strtrim(cellstr(num2str((1:k)', 'class=%d')));

% format the first output table
colNames = {sprintf('kmeans%d', k)};
tabName = [baseName sprintf('_kmeans%d', k)];
varargout{1} = Table(varargout{1}, colNames, obj.RowNames, 'name', tabName);

% if centroid output was asked, transform it into a table
if nargout > 1
    tabName = [baseName sprintf('_kmeans%d_centroids', k)];
    varargout{2} = Table(varargout{2}, obj.ColNames, groupNames, 'name', tabName);
end

% if individual-to-centroid distance is asked, convert to table
if nargout > 3
    varargout{4} = Table(varargout{4}, groupNames, obj.RowNames);
end


%% Process no-output case

% if no output is asked, display a map of the result
if nargout == 0
    if size(obj, 2) > 1
        scatterGroup(obj, 1, 2, varargout{1}, 1);
    end
    varargout = {};
end
