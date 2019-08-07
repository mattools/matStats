function res = cov(this)
%COV Covariance matrix of the data table
%
%   C = cov(TAB)
%   Compute the covariance matrix of the input table.
%
%   Example
%     % covariance matrix of iris data
%     iris = Table.read('fisherIris.txt');
%     cov(iris(:, 1:4))
%     ans = 
%                        SepalLength    SepalWidth    PetalLength    PetalWidth
%         SepalLength        0.68569     -0.039268         1.2737        0.5169
%          SepalWidth      -0.039268         0.188       -0.32171      -0.11798
%         PetalLength         1.2737      -0.32171         3.1132        1.2964
%          PetalWidth         0.5169      -0.11798         1.2964       0.58241
%
%
%   See also
%   std, var, corrcoef
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% check conditions
if hasFactors(this)
    error('Can not compute mean for table with factors');
end

data = cov(this.Data);

res = Table(data, 'rowNames', this.ColNames, 'colNames', this.ColNames);
