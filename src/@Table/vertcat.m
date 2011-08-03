function res = vertcat(this, varargin)
%VERTCAT Concatenate tables vertically
%
%   output = vertcat(input)
%
%   Example
%   vertcat
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

data = this.data;
rowNames = this.rowNames;
name = this.name;

for i = 1:length(varargin)
    var = varargin{i};
    
    data = [data ; var.data]; %#ok<AGROW>
    rowNames = [rowNames(:) ; var.rowNames(:)];
    name = strcat(name, '+', var.name);
end

res = Table.create(data, ...
    'parent', this, ...
    'rowNames', rowNames, ...
    'name', name);
