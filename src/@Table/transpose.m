function res = transpose(this)
%TRANSPOSE Transpose a data table and intervert names of row and columns
%
%   output = transpose(input)
%
%   Example
%   transpose
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% create table
res = Table(this);

% transpose data
res.data = this.data';

% switch names of rows and columns
res.rowNames = this.colNames;
res.colNames = this.rowNames;

% also add a small mark to the title
if ~isempty(this.name)
    res.name = [this.name ''''];
end
