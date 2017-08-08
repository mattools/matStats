function res = geomean(this, varargin)
%GEOMEAN Compute geometrical mean of table columns
%
%   M = geomean(TAB)
%   Computes the geomean of each column in the table. The result is a new
%   Table with one row, named 'geomean'.
%
%   M = geomean(TAB, DIM)
%   Specifies the dimension to operate. DIM can be either 1 (the default)
%   or 2. In the latter case, geomean is computed fo each row of the table,
%   and the result is a table with one column, called 'geomean'.
%
%   Example
%   geomean
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute geomean for table with factors');
end

dim = 1;
if ~isempty(varargin)
    dim = varargin{1};
end

newName = '';
if ~isempty(this.name)
    newName = ['geomean of ' this.name];
end

if dim == 1
    newData = exp(mean(log(this.data), 1));
    
    res = Table.create(newData, ...
        'rowNames', {'geomean'}, ...
        'colNames', this.colNames, ...
        'name', newName);
    
else
    newData = exp(mean(log(this.data), 2));
    res = Table.create(newData, ...
        'rowNames', this.rowNames, ...
        'colNames', {'geomean'}, ...
        'name', newName);
    
end
