function varargout = bar(varargin)
%BAR  Bar plot of the table data
%
%   bar(TAB)
%   Simple wrapper to the native bar function, that also displays
%   appropriate labels.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     res = groupStats(iris(:,1:4), iris(:,5), @mean);
%     bar(res')
%
%   See also
%     barweb

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

ind = cellfun('isclass', varargin, 'Table');

tab = varargin{ind};
varargin{ind} = tab.data;

h = bar(varargin{:});

set(gca, 'XTickLabel', tab.rowNames);
if size(tab, 1) > 1
    legend(tab.colNames);
end

if nargout > 0
    varargout = {h};
end