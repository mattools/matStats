function res = mean(this, varargin)
%MEAN Compute the mean of table columns
%
%   M = mean(TAB)
%   Computes the mean of each column in the table. The result is a new
%   Table with one row, named 'mean'.
%
%   M = mean(TAB, DIM)
%   Specifies the dimension to operate. DIM can be either 1 (the default)
%   or 2. In the latter case, mean is computed fo each row of the table,
%   and the result is a table with one column, called 'mean'.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     mean(iris(:,1:4))
%     ans =
%                 SepalLength    SepalWidth    PetalLength    PetalWidth
%         mean         5.8433         3.054         3.7587        1.1987
%
%   See also
%     median, std, var
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check conditions
if hasFactors(this)
    error('Can not compute mean for table with factors');
end

dim = 1;
if ~isempty(varargin)
    dim = varargin{1};
end

newName = '';
if ~isempty(this.Name)
    newName = ['Mean of ' this.Name];
end

if dim == 1
    res = Table.create(mean(this.data, 1), ...
        'rowNames', {'mean'}, ...
        'colNames', this.colNames, ...
        'name', newName);
    
else
    res = Table.create(mean(this.Data, 2), ...
        'rowNames', this.RowNames, ...
        'colNames', {'mean'}, ...
        'name', newName);
    
end
