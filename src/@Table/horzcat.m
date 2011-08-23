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

if isa(this, 'Table')
    data = this.data;
    parent = this;
    colNames = this.colNames;
    levels = this.levels;
    name = this.name;
    
else
    data = this;
    parent = varargin{1};
    colNames = strtrim(cellstr(num2str((1:size(data, 2))')));
    levels = cell(1, size(this, 2));
    name = 'NoName';
    
end

for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Table')
        data = [data var.data]; %#ok<AGROW>
        colNames = [colNames var.colNames]; %#ok<AGROW>
        name = strcat(name, '+', var.name);
        
    else
        data = [data var]; %#ok<AGROW>
        newCols = strtrim(cellstr(num2str((1:size(var, 2))')));
        colNames = [colNames(:) ; newCols(:)];
        name = strcat(name, '+', 'NoName');
        
    end

end

res = Table.create(data, ...
    'parent', parent, ...
    'colNames', colNames, ...
    'levels', levels, ...
    'name', name);
