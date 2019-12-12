function res = median(obj, varargin)
% Put the median of each column in a new table.
%
%   RES = median(TAB)
%   Computes the median of each column in the table, and put the result in
%   a new table.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     median(iris(:,1:4))
%     ans =
%                   SepalLength    SepalWidth    PetalLength    PetalWidth
%         median            5.8             3           4.35           1.3
%
%   See also
%     mean, std
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% check conditions
if hasFactors(obj)
    error('Can not compute median for table with factors');
end


newName = '';
if ~isempty(obj.Name)
    newName = ['Median of ' obj.Name];
end

res = Table.create(median(obj.Data, 1), ...
    'rowNames', {'median'}, ...
    'colNames', obj.ColNames, ...
    'name', newName);
    