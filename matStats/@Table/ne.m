function res = ne(obj1, obj2)
% Overload the ne operator for Table objects.
%
%   RES = ne(TAB1, TAB2)
%
%   Example
%   ne
%
%   See also
%   eq

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[dat1, dat2, parent, names1, names2] = parseInputCouple(obj1, obj2, inputname(1), inputname(2));

if ~hasFactors(parent)
    % compute new data with numeric data
    newData = bsxfun(@ne, dat1, dat2);
    
else
    % Case of factor data table
    if size(parent, 2) > 1
        error('Table:ne:FactorColumnForbidden', ...
            'If table is factor, it should have only one column');
    end
    
    % extract factor level for each row
    levels = parent.Levels{1};
    levels = levels(dat1);
    levels = levels(:);
    
    % compare factor levels with second argument
    if ischar(dat2)
        newData = ~strcmp(levels, dat2);
    else
        newData = bsxfun(@ne, levels, dat2);
    end
end

% create result array
res = Table.create(newData, ...
    'Parent', parent);

% update column names
colNames = strcat(names1, '~=', names2);
if length(colNames) == size(res, 2)
    res.ColNames = colNames;
end

% clear levels
res.Levels = cell(1, size(res, 2));
