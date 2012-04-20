function res = std(this, varargin)
%STD Put the std of each column in a new table
%
%   RES = std(TAB)
%   Computes the standard deviation of each column in the table, and put
%   the result in a new table.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     std(iris(:,1:4))
%     ans =
%                SepalLength    SepalWidth    PetalLength    PetalWidth
%         std        0.82807       0.43359         1.7644       0.76316
%
%   See also
%   var, mean
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
    newName = ['Std of ' this.name];
end

res = Table.create(std(this.data, 0, 1), ...
    'rowNames', {'std'}, ...
    'colNames', this.colNames, ...
    'name', newName);
    