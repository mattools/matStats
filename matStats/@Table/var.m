function res = var(this, varargin)
%VAR Put the variance of each column in a new table
%
%   output = var(input)
%
%   Example
%   var
%
%   See also
%     std, mean
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute var for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['Var of ' this.Name];
end

res = Table.create(var(this.Data, 1), ...
    'rowNames', {'var'}, ...
    'colNames', this.ColNames, ...
    'name', newName);
    