function [res, I] = sortrows(obj, varargin)
% Sort entries of data table according to row names.
%
%   TAB2 = sortrows(TAB)
%   Sorts data table according to row names
%
%   TAB2 = sortrows(TAB, COL)
%   Sorts data table according to entry specified by COL. COL can be either
%   an index or the name of a column.  
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     sortrows(iris(1:10, :), 1)
%     ans = 
%               SepalLength    SepalWidth    PetalLength    PetalWidth    Species
%     9                 4.4           2.9            1.4           0.2     Setosa
%     4                 4.6           3.1            1.5           0.2     Setosa
%     7                 4.6           3.4            1.4           0.3     Setosa
%     3                 4.7           3.2            1.3           0.2     Setosa
%     2                 4.9             3            1.4           0.2     Setosa
%     10                4.9           3.1            1.5           0.1     Setosa
%     5                   5           3.6            1.4           0.2     Setosa
%     8                   5           3.4            1.5           0.2     Setosa
%     1                 5.1           3.5            1.4           0.2     Setosa
%     6                 5.4           3.9            1.7           0.4     Setosa
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% determines row order
if isempty(varargin)
    % if no argument, use row names for ordering
    if isempty(obj.RowNames)
        error('Table:sortrows', 'Requires valid row names, or a column index');
    end
    [dum, I] = sortrows(obj.RowNames); %#ok<ASGLU>
else
    ind = columnIndex(obj, varargin{1});
    [dum, I] = sortrows(obj.Data(:, ind)); %#ok<ASGLU>
end

% transform data
res = Table(obj.Data(I,:), 'rowNames', obj.RowNames(I), 'parent', obj);
