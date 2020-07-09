function res = vertcat(obj, varargin)
% Concatenate Spectra data vertically.
%
%   RES = vertcat(TAB1, TAB2)
%   RES = [TAB1 ; TAB2];
%   Concatenate vertically two spectra data sets.
%
%   RES = vertcat(TAB1, TAB2, TAB3,...)
%   RES = [TAB1 ; TAB2 ; TAB3 ... ];
%   Concatenate vertically multiple spectra data sets.
%
%   Example
%   vertcat
%
%   See also
%     horzcat, cat, interleave, aggregate
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% detect which argument is table object
if isa(obj, 'Spectra')
    data = obj.Data;
    rowNames = obj.RowNames;
    name = obj.Name;
    nCols = size(obj.Data, 2);
    
else
    data = obj;
    nCols = size(data, 2);
    rowNames = strtrim(cellstr(num2str((1:size(data, 1))')));
    name = 'NoName';
    
end

% init levels array
xvalues = zeros(1, nCols);
if isa(obj, 'Spectra')
    xvalues = obj.XValues;
end

% iterate over
for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Spectra')
        if size(var.Data, 2) ~= nCols
            error('Spectra:vertcat:wrongsize', ...
                'Input Spectra must have the same number of columns');
        end
        
        data2 = var.Data;
        data = [data ; data2]; %#ok<AGROW>

        rowNames = [rowNames(:) ; var.RowNames(:)];
        name = strcat(name, '+', var.Name);
        
    else
        if size(var, 2) ~= nCols
            error('Spectra:vertcat:wrongsize', ...
                'Input data must have the same number of columns');
        end
        
        data = [data ; var]; %#ok<AGROW>
        newRows = strtrim(cellstr(num2str((1:size(var, 1))')));
        rowNames = [rowNames(:) ; newRows(:)];
        name = strcat(name, '+', 'NoName');
        
    end
    
end

% create the result table
res = Spectra.create(data, xvalues, ... 
    'rowNames', rowNames, ...
    'name', name);

