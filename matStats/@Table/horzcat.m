function res = horzcat(obj, varargin)
% Concatenate tables horizontally.
%
%   RES = horzcat(TAB1, TAB2)
%
%   Example
%   horzcat
%
%   See also
%     vertcat

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(obj, 'Table')
    data = obj.Data;
    parent = obj;
    colNames = obj.ColNames;
    levels = obj.Levels;
    plotTypes = obj.PreferredPlotTypes;
    name = obj.Name;
    
else
    data = obj;
    parent = varargin{1};
    colNames = strtrim(cellstr(num2str((1:size(data, 2))')));
    levels = cell(1, size(obj, 2));
    plotTypes = repmat({'line'}, 1, size(obj, 2));
    name = 'NoName';
    
end

for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Table')
        data = [data var.Data]; %#ok<AGROW>
        colNames = [colNames var.ColNames]; %#ok<AGROW>
        levels = [levels var.Levels]; %#ok<AGROW>
        plotTypes = [plotTypes var.PreferredPlotTypes]; %#ok<AGROW>
        name = strcat(name, '+', var.Name);
        
    else
        data = [data var]; %#ok<AGROW>
        newCols = strtrim(cellstr(num2str((1:size(var, 2))')));
        colNames = [colNames(:) ; newCols(:)];
        levels = [levels cell(1, size(var, 2))]; %#ok<AGROW>
        plotTypes = [plotTypes repmat({'line'}, 1, size(var, 2))]; %#ok<AGROW>
        name = strcat(name, '+', 'NoName');
        
    end

end

res = Table.create(data, ...
    'Parent', parent, ...
    'ColNames', colNames, ...
    'RowNames', obj.RowNames, ...
    'Levels', levels, ...
    'PreferredPlotTypes', plotTypes, ...
    'Name', name);
