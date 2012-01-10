function res = corrcoef(this)
%CORRCOEF Correlation coefficients of table data
%
%   CORR = corrcoef(TAB)
%
%   Example
%   corrcoef
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

data = corrcoef(this.data);

res = Table(data, 'rowNames', this.colNames, 'colNames', this.colNames);
