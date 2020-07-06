function res = not(obj)
% Invert logical values of table.
%
%   RES = not(TAB)
%   RES = ~TAB
%   Returns table with same row names and column names, but whose values
%   are 1-complemented.
%
%   Example
%   not
%
%   See also
%     eq, ne
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute not for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['not of ' obj.Name];
end

newColNames = strcat('not', obj.ColNames);

res = Table.create(not(obj.Data), ...
    'Parent', obj, ...
    'Name', newName, ...
    'ColNames', newColNames);
    