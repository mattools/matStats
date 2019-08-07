function res = min(this, varargin)
%MIN Put the min of each column in a new table
%
%   output = min(input)
%
%   Example
%   min
%
%   See also
%     max, mean
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if hasFactors(this)
    error('Can not compute min for table with factors');
end

newName = '';
if ~isempty(this.Name)
    newName = ['Min of ' this.Name];
end

res = Table.create(min(this.Data, [], 1), ...
    'rowNames', {'min'}, ...
    'colNames', this.ColNames, ...
    'name', newName);
    