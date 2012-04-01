function res = transpose(this)
%TRANSPOSE Transpose a data table and intervert names of row and columns
%
%   RES = transpose(TAB)
%   Returns a new data with transposed data array, and swaped column and
%   row names.
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

% create table with transposed data
res = Table(this.data', this.rowNames', this.colNames');

% also add a small mark to the title
if ~isempty(this.name)
    res.name = [this.name ''''];
end
