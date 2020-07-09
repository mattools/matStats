function res = horzcat(obj, varargin)
% Concatenate Spectra data sets horizontally.
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

if isa(obj, 'Spectra')
    data = obj.Data;
    parent = obj;
    xvalues = obj.XValues;
    name = obj.Name;
    
else
    data = obj;
    parent = varargin{1};
    xvalues = 1:size(data, 2);
    name = 'NoName';
    
end

for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Spectra')
        data = [data var.Data]; %#ok<AGROW>
        xvalues = [xvalues var.XValues]; %#ok<AGROW>
        name = strcat(name, '+', var.Name);
        
    else
        data = [data var]; %#ok<AGROW>
        newVals = 1:size(var, 2);
        xvalues = [xvalues ; newVals]; %#ok<AGROW>
        name = strcat(name, '+', 'NoName');
        
    end

end

res = Spectra.create(data, xvalues, ...
    'parent', parent, ...
    'rowNames', obj.RowNames, ...
    'name', name);
