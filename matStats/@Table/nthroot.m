function res = nthroot(obj, n)
% N-th root of table values.
%
%   RES = nthroot(TAB)
%   Returns table with same row names and column names, but whose values
%   are the n-th roots of the values in the table.
%
%   Example
%   nthroot
%
%   See also
%     mpower, sqrt
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(obj)
    error('Can not compute nthroot for table with factors');
end

newName = '';
if ~isempty(obj.Name)
    newName = ['nthroot of ' obj.Name];
end

newColNames = strcat('nthroot', obj.ColNames);

res = Table.create(nthroot(obj.Data, n), ...
    'Parent', obj, ...
    'Name', newName, ...
    'ColNames', newColNames);
    