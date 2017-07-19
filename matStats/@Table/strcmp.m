function res = strcmp(this, that)
%STRCMP Compare factor levels with a string
%
%   TF = strcmp(TAB)
%
%   Example
%   eq
%
%   See also
%   eq, ne

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-08-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2015 INRA - Cepia Software Platform.

[dat1, dat2, parent, names1, names2] = parseInputCouple(this, that, inputname(1), inputname(2));

% Limited to one-column tables
if size(parent, 2) > 1
    error('Table:strcmp:FactorColumnForbidden', ...
        'Table should have only one column');
end

% Resticted to tables with factor column 
if ~hasFactors(parent)
    % compute new data, with numeric data
    error('Table:strcmp:NumericalTable', ...
        'input table can not be numerical');
end

% extract factor level for each row
levels = parent.levels{1};
levels = levels(dat1);
levels = levels(:);

% compare factor levels with second argument
if ischar(dat2)
    newData = strcmp(levels, dat2);
else
    error('Table:strcmp:NumericalArgument', ...
        'second argument must be a character array');
end

newColNames = strcat(names1, '==', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);

% clear levels
res.levels = cell(1, size(res, 2));
