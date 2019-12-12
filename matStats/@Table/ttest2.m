function varargout = ttest2(tab1, tab2, varargin)
% Two-sample t-test.
%
%   H = ttest2(TAB1, TAB2)
%   [H, P] = ttest2(TAB1, TAB2)
%   Simple wrapper for the Matlab ttest2 function, that manages Table
%   objects containing only one column with quantitative data.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     indVersi = find(iris('Species') == 'Versicolor');
%     indSetosa = find(iris('Species') == 'Setosa');
%     [h p] = ttest2(iris(indVersi, 'PetalLength'), iris(indSetosa, 'PetalLength'))
%     h =
%          1
%     p =
%       5.7175e-062
%
%   See also
%     Anova

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-02-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% extract first variable
if isa(tab1, 'Table')
    if hasFactors(tab1)
        error('Can not compute TTEST2 for table with factors');
    end
    data1 = tab1.Data;
else
    data1 = tab1;
end

% extract second variable
if isa(tab2, 'Table')
    if hasFactors(tab2)
        error('Can not compute TTEST2 for table with factors');
    end
    data2 = tab2.Data;
else
    data2 = tab2;
end

% call ttest2 function
varargout = cell(max(1, nargout), 1);
[varargout{:}] = ttest2(data1, data2, varargin{:});
