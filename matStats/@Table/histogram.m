function histogram(this, varargin)
%HISTOGRAM Histogram plot of a column in a data table
%
%   histogram(TAB)
%   Displays histogram of table object TAB, that is assumed to contains
%   only one column.
%
%   histogram(TAB, OPTIONS)
%   Uses additional options that are passed to the native 'histogram'
%   function.
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     figure; histogram(tab('PetalLength'), 10);
%
%   See also
%     plot, plotmatrix
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if size(this.Data, 2) == 1
    % if table has only one column, use it for histogram
    data = this.Data;
    
else
    % Otherwise, need to specify the index or name of column
    
    % find index of first column
    if nargin < 2
        error('can not display histogram of a table with several columns');
    end
    
    % extract index of column to display
    var = varargin{1};
    varargin(1) = [];
    ind = columnIndex(this, var);
    if isempty(ind) > 0
        error(['input table does not contain column named "' var '"']);
    end

    % extract column data
    ind = ind(1);
    data = this.Data(:, ind);
    
end

% histogram of the selected column
histogram(data, varargin{:});
xlabel(this.ColNames{1});

if ~isempty(this.Name)
    title(this.Name);
end