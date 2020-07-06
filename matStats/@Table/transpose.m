function res = transpose(obj)
% Transpose a data table and swap names of row and columns.
%
%   RES = transpose(TAB)
%   Returns a new data with transposed data array, and swaped column and
%   row names.
%
%   Example
%   transpose
%
%   See also
%     size, reshape
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% create table with transposed data
res = Table.create(obj.Data', obj.RowNames', obj.ColNames');

% also add a small mark to the title
if ~isempty(obj.Name)
    res.Name = [obj.Name ''''];
end
