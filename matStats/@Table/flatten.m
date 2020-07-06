function res = flatten(obj)
% Transform the data table into a single column table.
%
%   res = flatten(TAB)
%   Transform the data table into a single column table
%   Vector is created by travelling along rows first.
%
%   Example
%     flatten(iris(1:3, 1:4))
%     ans =
%         5.1000
%         4.9000
%         4.7000
%         3.5000
%         3.0000
%         3.2000
%         1.4000
%         1.4000
%         1.3000
%         0.2000
%         0.2000
%         0.2000
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

data = obj.Data';
res = Table.create(data(:)); 
