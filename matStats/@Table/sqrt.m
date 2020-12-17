function res = sqrt(obj)
% Square root of table values.
%
%   RES = sqrt(TAB)
%   Returns table with same row names and column names, but whose values
%   are the sqrtarithms of the values in the table.
%
%   Example
%   sqrt
%
%   See also
%     power, log
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute sqrt for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Sqrt of ' obj.Name];
end

res = Table.create(sqrt(obj.Data), 'Parent', obj, 'Name', newName);

% update column names
if ~isempty(obj.ColNames)
    res.ColNames = strcat('sqrt', obj.ColNames);
end
    