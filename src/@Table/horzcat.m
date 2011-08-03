function res = horzcat(this, varargin)
%HORZCAT Concatenate tables horizontally
%
%   output = horzcat(input)
%
%   Example
%   horzcat
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

data = this.data;
colNames = this.colNames;
name = this.name;

for i = 1:length(varargin)
    var = varargin{i};
    
    data = [data var.data]; %#ok<AGROW>
    colNames = [colNames var.colNames];     %#ok<AGROW>
    name = strcat(name, '+', var.name);
end

res = Table.create(data, ...
    'parent', this, ...
    'colNames', colNames, ...
    'name', name);
