function res = mean(this, varargin)
%MEAN Put the mean of each column in a new table
%
%   M = mean(TAB)
%   Computes the mean of eacjh column in theatable. The result is a new
%   Table with one row, named 'mean'.
%
%   M = mean(TAB, DIM)
%   Specifies the dimension to operate. DIM can be either 1 (the default)
%   or 2. In the latter case, mean is computed fo each row of the table,
%   and the result is a table with one column, called 'mean'.
%
%   Example
%   mean
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute mean for table with factors');
end

dim = 1;
if ~isempty(varargin)
    dim = varargin{1};
end

newName = '';
if ~isempty(this.name)
    newName = ['Mean of ' this.name];
end

if dim == 1
    res = Table.create(mean(this.data, 1), ...
        'rowNames', {'mean'}, ...
        'colNames', this.colNames, ...
        'name', newName);
    
else
    res = Table.create(mean(this.data, 2), ...
        'rowNames', this.rowNames, ...
        'colNames', {'mean'}, ...
        'name', newName);
    
end
