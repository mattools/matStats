function res = isFactor(this, colName)
%ISFACTOR Check if a column is treated as a factor
%
%   B = isFactor(TAB, COLNAME)
%   Returns TRUE if the column specified by COLNAME in the table TAB is
%   treated as a factor.
%
%
%   Example
%   isFactor
%
%   See also
%   Table/setAsFactor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% extract index of column
ind = columnIndex(this, colName);

res = false(1, length(ind));
for i = 1:length(ind)
    if ind(i) <= length(this.levels)
        res(i) = ~isempty(this.levels{ind(i)});
    end
end
