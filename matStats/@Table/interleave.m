function res = interleave(obj1, obj2)
% Interleave the rows of two data tables.
%
%   RES = interleave(TAB1, TAB2)
%   Concatenates the rows of the two data tables. Both data tables must
%   have the same number of rows and columns.
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     tabMean = aggregate(tab(:, 1:4), tab('Species'));
%     tabStd  = aggregate(tab(:, 1:4), tab('Species'), @std);
%     res = interleave(tabMean, tabStd)
%         res =
%                                SepalLength    SepalWidth    PetalLength    PetalWidth
%         Setosa-mean                  5.006         3.428          1.462         0.246
%         Setosa-std                 0.35249       0.37906        0.17366       0.10539
%         Versicolor-mean              5.936          2.77           4.26         1.326
%         Versicolor-std             0.51617        0.3138        0.46991       0.19775
%         Virginica-mean               6.588         2.974          5.552         2.026
%         Virginica-std              0.63588        0.3225        0.55189       0.27465
% 
%
%   See also
%     horzcat, aggregate
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2017-05-22,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% check validity of inputs
dim1 = size(obj1);
dim2 = size(obj2);
if any(dim1 ~= dim2)
    error('Both input tables must have the same size');
end

% create result array
nRows = 2 * dim1(1);
dim = [nRows, dim1(2)];
res = Table.create(zeros(dim), obj1.ColNames, 'Parent', obj1);

% check presence of factors
if hasFactors(obj1) || hasFactors(obj2)
    warning('Table:interleave:NotImplemented', ...
        'The management of factors is not implemented');
end

% fill in with data
res.Data(1:2:nRows, :) = obj1.Data;
res.Data(2:2:nRows, :) = obj2.Data;
if ~isempty(obj1.RowNames) && ~isempty(obj2.RowNames)
    res.RowNames(1:2:nRows) = obj1.RowNames;
    res.RowNames(2:2:nRows) = obj2.RowNames;
end
