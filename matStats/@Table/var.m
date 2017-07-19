function res = var(this, varargin)
%VAR Put the variance of each column in a new table
%
%   output = var(input)
%
%   Example
%   var
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute var for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['Var of ' this.name];
end

res = Table.create(var(this.data, 1), ...
    'rowNames', {'var'}, ...
    'colNames', this.colNames, ...
    'name', newName);
    