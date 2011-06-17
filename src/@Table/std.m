function res = std(this, varargin)
%STD Put the std of each column in a new table
%
%   output = std(input)
%
%   Example
%   std
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
    error('Can not compute std for table with factors');
end

newName = '';
if ~isempty(this.name)
    newName = ['Std of ' this.name];
end

res = Table.create(std(this.data, 0, 1), ...
    'rowNames', {'std'}, ...
    'colNames', this.colNames, ...
    'name', newName);
    