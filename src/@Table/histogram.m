function varargout = histogram(this, var, varargin)
%HISTOGRAM Histogram plot of a column in a data table
%
%   TABLE.histogram(COLNAME)
%   where TABLE is a Table object, and COLNAME is either index or name of 
%   a column of the table.
%
%
%   Example
%   histogram
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('Table:histogram:deprecated', ...
    'function "histogram" is deprecated, use "hist" instead');

% find index of first column
ind = this.columnIndex(var);
if isempty(ind)>0
    error(['input table does not contain column named "' var '"']);
end

% extract column data
ind = ind(1);
col = this.data(:, ind);

% scatter plot of selected columns
hist(col, varargin{:});
xlabel(this.colNames{ind});
if ~isempty(this.name)
    title(this.name);
end

% eventually returns handle to graphics
if nargout > 0
    varargout = {h};
end
