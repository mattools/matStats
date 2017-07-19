function res = bsxfun(fun, this, that)
%BSXFUN Binary Singleton Expansion Function for Table
%
%   RES = bsxfun(FUN, A, B)
%
%   Example
%     % Compute binary expansion with minus on iris table
%     tab = Table.read('fisherIris.txt');
%     tab = tab(:, 1:end-1);
%     means = tab;
%     res = bsxfun(@minus, tab, means);
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-08-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

[data1, data2, parent] = parseInputCouple(this, that);

% error checking
if hasFactors(parent)
    error('Can not compute bsxfun for table with factors');
end

% call bsxfun on inner data
newData = bsxfun(fun, data1, data2);

% newColNames = strcat(names1, '+', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent);
