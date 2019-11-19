function varargout = scatterPlot(obj, var1, var2, varargin)
%SCATTERPLOT Scatter plot of two columns in a table
%
%   Note: deprecated, use scatter instead
%
%   scatterPlot(TAB, VAR1, VAR2)
%   where TABLE is a Table object, and VAR1 and VAR2 are either indices or
%   names of 2 columns in the table, scatter the individuals given with
%   given coordinates
%
%   scatterPlot(TAB, VAR1, VAR2, STYLE)
%   scatterPlot(..., PARAM, VALUE)
%   Specifies drawing options
%
%   Example
%   scatterPlot
%
%   See also
%     plot, scatter
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('Table:scatterPlot:deprecated', ...
    'function "scatterPlot" is deprecated, use "scatter" instead');

% index of first column
ind1 = columnIndex(obj, var1);
col1 = obj.Data(:, ind1(1));

% index of second column
ind2 = columnIndex(obj, var2);
col2 = obj.Data(:, ind2(1));

% check if drawing style is ok to plot points
if isempty(varargin)
    varargin = {'+b'};
end

% scatter plot of selected columns
h = plot(col1, col2, varargin{:});

% add plot annotations
xlabel(obj.ColNames{ind1});
ylabel(obj.ColNames{ind2});
if ~isempty(obj.Name)
    title(obj.Name, 'Interpreter', 'none');
end

% eventually returns handle to graphics
if nargout > 0
    varargout = {h};
end
