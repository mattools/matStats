function res = corrcoef(obj, varargin)
% Correlation coefficients of table data.
%
%   CORRMAT = corrcoef(TAB)
%   Returns a new data table givin the correlation coefficient of each
%   couple of parameters in the input table TAB.
%   The result CORRMAT is a data table with as many rows and columns as the
%   number of variables in the input table.
%
%   CORR = corrcoef(T1, T2)
%   Returns the correlation coefficient of the values in the two tables.
%   Values in each table are first linearised, then the correlation
%   coefficient is computed. The result is a scalar.
%
%   Example
%     % correlation matrix of iris data
%     iris = Table.read('fisherIris.txt');
%     corrcoef(iris(:, 1:4))
%     ans = 
%                        SepalLength    SepalWidth    PetalLength    PetalWidth
%         SepalLength              1      -0.10937        0.87175       0.81795
%          SepalWidth       -0.10937             1       -0.42052      -0.35654
%         PetalLength        0.87175      -0.42052              1       0.96276
%          PetalWidth        0.81795      -0.35654        0.96276             1
%
%     corrcoef(iris('PetalLength'), iris('SepalLength'))
%     ans =
%          0.8718
%
%   See also
%     std, cov, correlationCircles
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if nargin == 1
    % compute correlation coefficient of each couple of variables
    data = corrcoef(obj.Data);
    res = Table(data, 'rowNames', obj.ColNames, 'colNames', obj.ColNames);

else
    % compute only one correlation coefficient
    data2 = varargin{1};
    if isa(data2, 'Table')
        data2 = data2.Data;
    end
    
    data1 = obj;
    if isa(data1, 'Table')
        data1 = data1.Data;
    end
    
    % correlation coefficient matrix
    mat = corrcoef(data1(:), data2(:));
    
    res = mat(1,2);
end
