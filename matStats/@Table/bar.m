function varargout = bar(varargin)
% Bar plot of the table data.
%
%   Deprecated: use 'barPlot' instead.
%
%   bar(TAB)
%   Simple wrapper to the native "bar" function from Matlab, that also
%   displays appropriate labels and legend.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     res = groupStats(iris(:,1:4), iris(:,5), @mean);
%     bar(res')
%
%   See also
%     barweb, plot, stem, stairs

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

warning('MatStats:deprecated', ...
    'function bar is obsolete, use barPlot instead');

% replaces table by its data
ind = cellfun('isclass', varargin, 'Table');
obj = varargin{ind};
varargin{ind} = obj.Data;

% parse legend location info
legendLocation = 'NorthEast';
ind = find(cellfun(@(x)strcmpi(x, 'LegendLocation'), varargin), 1);
if ~isempty(ind)
    legendLocation = varargin{ind+1};
    varargin(ind:ind+1) = [];
end

% display the bar
h = bar(varargin{:});

% format figure
if ~isempty(obj.RowNames)
    set(gca, 'XTickLabel', obj.RowNames);
end
if size(obj, 1) > 1
    legend(obj.ColNames, 'Location', legendLocation);
end

% return handle
if nargout > 0
    varargout = {h};
end