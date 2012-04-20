function varargout = bar(varargin)
%BAR  Bar plot of the table data
%
%   bar(TAB)
%   Simple wrapper to the native bar function, that also display
%   appropriate labels.
%   Note: the table is transposed before display.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     res = groupStats(iris(:,1:4), iris(:,5), @mean);
%     bar(res)
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

ind = cellfun('isclass', varargin, 'Table');

tab = varargin{ind};
varargin{ind} = tab.data';

h = bar(varargin{:});

set(gca, 'XTickLabel', tab.colNames);
if size(tab, 1) > 1
    legend(tab.rowNames);
end

if nargout > 0
    varargout = {h};
end