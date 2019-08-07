function res = nthroot(this, n)
%NTHROOT N-th root of table values
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


if hasFactors(this)
    error('Can not compute nthroot for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['nthroot of ' this.Name];
end

newColNames = strcat('nthroot', this.ColNames);

res = Table.create(nthroot(this.Data, n), ...
    'parent', this, ...
    'name', newName, ...
    'colNames', newColNames);
    