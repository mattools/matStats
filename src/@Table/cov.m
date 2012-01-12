function res = cov(this)
%COV Covariance matrix of the data table
%
%   C = cov(TAB)
%
%   Example
%   cov(TAB)
%
%   See also
%   std, var, corrcoef
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

data = cov(this.data);

res = Table(data, 'rowNames', this.colNames, 'colNames', this.colNames);
