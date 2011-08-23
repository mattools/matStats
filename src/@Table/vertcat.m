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

if isa(this, 'Table')
    data = this.data;
    rowNames = this.rowNames;
    name = this.name;
    
else
    data = this;
    rowNames = strtrim(cellstr(num2str((1:size(data, 1))')));
    name = 'NoName';
    
end


for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Table')
        data = [data ; var.data]; %#ok<AGROW>
        rowNames = [rowNames(:) ; var.rowNames(:)];
        name = strcat(name, '+', var.name);
        
    else
        data = [data ; var]; %#ok<AGROW>
        newRows = strtrim(cellstr(num2str((1:size(var, 1))')));
        rowNames = [rowNames(:) ; newRows(:)];
        name = strcat(name, '+', 'NoName');
        
    end
    

end

res = Table.create(data, ...
    'rowNames', rowNames, ...
    'name', name);
