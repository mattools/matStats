function res = interleave(this, that)
%INTERLEAVE Interleave the rows of two data tables
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
%                                   SepalLength    SepalWidth    PetalLength    PetalWidth
%         Species=Setosa                  5.006         3.428          1.462         0.246
%         Species=Setosa                0.35249       0.37906        0.17366       0.10539
%         Species=Versicolor              5.936          2.77           4.26         1.326
%         Species=Versicolor            0.51617        0.3138        0.46991       0.19775
%         Species=Virginica               6.588         2.974          5.552         2.026
%         Species=Virginica             0.63588        0.3225        0.55189       0.27465
% 
%
%   See also
%     horzcat, aggregate
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-05-22,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% check validity of inputs
dim1 = size(this);
dim2 = size(that);
if any(dim1 ~= dim2)
    error('Both input tables must have the same size');
end

% create result array
nRows = 2 * dim1(1);
dim = [nRows, dim1(2)];
res = Table(zeros(dim), this.colNames);
res.levels = this.levels;

% check presence of factors
if hasFactors(this) || hasFactors(that)
    warning('Table:interleave:NotImplemented', ...
        'The management of factors is not implemented');
end

% fill in with data
res.data(1:2:nRows, :) = this.data;
res.data(2:2:nRows, :) = that.data;
res.rowNames(1:2:nRows) = this.rowNames;
res.rowNames(2:2:nRows) = that.rowNames;
    
