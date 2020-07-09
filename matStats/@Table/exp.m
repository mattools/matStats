function res = exp(obj)
% Exponential of table values.
%
%   RES = exp(TAB)
%   Returns table with same row names and column names, but whose values
%   are the exponential of the values in the table.
%
%   Example
%     tab = Table.create([0; 1; 2; 3]);
%     exp(tab)
%     ans = 
%         expdata
%               1
%         2.71828
%         7.38906
%         20.0855
%
%   See also
%     log, sqrt

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute exp for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Exp of ' obj.Name];
end

newColNames = strcat('exp', obj.ColNames);

res = newInstance(obj, exp(obj.Data), 'Parent', obj, ...
    'Name', newName, ...
    'ColNames', newColNames);
    