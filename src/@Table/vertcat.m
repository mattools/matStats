function res = vertcat(this, varargin)
%VERTCAT Concatenate tables vertically
%
%   RES = vertcat(TAB1, TAB2)
%   RES = [TAB1 ; TAB2];
%   Concatenate vertically two data tables.
%
%   RES = vertcat(TAB1, TAB2, TAB3,...)
%   RES = [TAB1 ; TAB2 ; TAB3 ... ];
%   Concatenate vertically multiple data tables.
%
%   Example
%   vertcat
%
%   See also
%   horzcat, cat
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% detect which argument is table object
if isa(this, 'Table')
    data = this.data;
    rowNames = this.rowNames;
    name = this.name;
    nCols = size(this.data, 2);
    
else
    data = this;
    nCols = size(data, 2);
    rowNames = strtrim(cellstr(num2str((1:size(data, 1))')));
    name = 'NoName';
    
end

% init levels array
colNames = cell(1, nCols);
levels = cell(1, nCols);
if isa(this, 'Table')
    colNames = this.colNames;
    levels = this.levels;
end

% iterate over
for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Table')
        if size(var.data, 2) ~= nCols
            error('Table:vertcat:wrongsize', ...
                'Input tables must have the same number of columns');
        end
        data = [data ; var.data]; %#ok<AGROW>
        rowNames = [rowNames(:) ; var.rowNames(:)];
        name = strcat(name, '+', var.name);
        
        % if some levels are more numerous, keep the most numerous ones
        inds = find(cellfun(@length, var.levels) > cellfun(@length, levels));
        for j = 1:length(inds)
            levels{inds(j)} = var.levels{inds(j)};
        end

    else
        if size(var, 2) ~= nCols
            error('Table:vertcat:wrongsize', ...
                'Input data must have the same number of columns');
        end
        
        data = [data ; var]; %#ok<AGROW>
        newRows = strtrim(cellstr(num2str((1:size(var, 1))')));
        rowNames = [rowNames(:) ; newRows(:)];
        name = strcat(name, '+', 'NoName');
        
    end
    
end

% create the result table
res = Table.create(data, ...
    'rowNames', rowNames, ...
    'colNames', colNames, ...
    'levels',   levels, ...
    'name', name);

