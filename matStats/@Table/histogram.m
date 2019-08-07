function histogram(this, var, varargin)
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
%     hist

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('Table:histogram:deprecated', ...
    'function "histogram" is deprecated, use "hist" instead');

% find index of first column
ind = columnIndex(this, var);
if isempty(ind)>0
    error(['input table does not contain column named "' var '"']);
end

% extract column data
ind = ind(1);
col = this.Data(:, ind);

% scatter plot of selected columns
histogram(col, varargin{:});
xlabel(this.ColNames{ind});
if ~isempty(this.Name)
    title(this.Name);
end

