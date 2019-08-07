function res = median(this, varargin)
%MEDIAN Put the median of each column in a new table
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
if hasFactors(this)
    error('Can not compute median for table with factors');
end


newName = '';
if ~isempty(this.Name)
    newName = ['Median of ' this.Name];
end

res = Table.create(median(this.Data, 1), ...
    'rowNames', {'median'}, ...
    'colNames', this.ColNames, ...
    'name', newName);
    