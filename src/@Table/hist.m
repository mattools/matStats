function hist(this, varargin)
%HIST Histogram plot of a column in a data table
%
%   hist(TAB)
%   Displays histogram of table object TAB, that is assumed to contains
%   only one column.
%
%
%   Example
%     % Histogram of Iris Sepal Length
%     iris = Table.read('fisherIris');
%     hist(iris('SepalLength'), 20);
%
%   See also
%     plotmatrix
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if size(this.data, 2) == 1
    % if table has only one column, use it for histogram
    data = this.data;
    
else
    % Otherwise, need to specify the index or name of column
    
    % find index of first column
    if nargin < 2
        error('can not display histogram of a table with several columns');
    end
    
    % extract index of column to display
    var = varargin{1};
    varargin(1) = [];
    ind = this.columnIndex(var);
    if isempty(ind) > 0
        error(['input table does not contain column named "' var '"']);
    end

    % extract column data
    ind = ind(1);
    data = this.data(:, ind);
    
end

% histogram of the selected column
hist(data, varargin{:});
xlabel(this.colNames{1});

if ~isempty(this.name)
    title(this.name);
end

% % eventually returns handle to graphics
% if nargout > 0
%     varargout = {h};
% end
