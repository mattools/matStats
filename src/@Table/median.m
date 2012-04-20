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
%   mean, std
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% check conditions
if hasFactors(this)
    error('Can not compute mean for table with factors');
end


newName = '';
if ~isempty(this.name)
    newName = ['Median of ' this.name];
end

res = Table.create(median(this.data, 1), ...
    'rowNames', {'median'}, ...
    'colNames', this.colNames, ...
    'name', newName);
    