function res = isFactor(obj, colName)
% Check if a column is treated as a factor.
%
%   B = isFactor(TAB, COLNAME)
%   Returns TRUE if the column specified by COLNAME in the table TAB is
%   treated as a factor.
%
%
%   Example
%     iris = Table.read('fisherIris');
%     isFactor(iris, 'Species')
%     ans = 
%         1
%     isFactor(iris, 'PetalLength')
%     ans = 
%         0
%
%   See also
%     setAsFactor, trimLevels
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% extract index of column
ind = columnIndex(obj, colName);

% result is a row vector with the same number of columns as the number of
% indices
res = false(1, length(ind));

% check if input column
for i = 1:length(ind)
    if ind(i) <= length(obj.Levels)
        res(i) = ~isempty(obj.Levels{ind(i)});
    end
end
