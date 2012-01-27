function res = corrcoef(this, varargin)
%CORRCOEF Correlation coefficients of table data
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
%   corrcoef
%
%   See also
%     std, cov
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if nargin == 1
    % compute correlation coefficient of each couple of variables
    data = corrcoef(this.data);
    res = Table(data, 'rowNames', this.colNames, 'colNames', this.colNames);

else
    % compute only one correlation coefficient
    data2 = varargin{1};
    if isa(data2, 'Table')
        data2 = data2.data;
    end
    
    data1 = this;
    if isa(data1, 'Table')
        data1 = data1.data;
    end
    
    % correlation coefficient matrix
    mat = corrcoef(data1(:), data2(:));
    
    res = mat(1,2);
end
