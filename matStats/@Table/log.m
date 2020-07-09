function res = log(obj)
% Logarithm of table values.
%
%   RES = log(TAB)
%   Returns table with same row names and column names, but whose values
%   are the logarithms of the values in the table.
%
%   Example
%     tab = Table.create([1;2;3;4;5]);
%     log(tab)
%     ans = 
%         logdata
%               0
%         0.69315
%          1.0986
%          1.3863
%          1.6094
%
%   See also
%     expn log2, log10, sqrt
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute log for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Log of ' obj.Name];
end

newColNames = strcat('log', obj.ColNames);

res = newInstance(obj, log(obj.Data), 'Parent', obj, ...
    'Name', newName, ...
    'ColNames', newColNames);
    