function res = apply(this, fun, varargin)
%APPLY Apply the given function to each element of the table
%
%   RES = apply(TAB, FUN)
%   TAB is a data table, and FUN is a function handle. 
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     res = apply(tab(:,1:4), @log);
%     mean(res)
%
%   See also
%     aggregate

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-07-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

res = zeros(size(this.Data));

for i = 1:numel(this.Data)
    res(i) = fun(this.Data(i));
end

res = Table(res, this.ColNames, this.RowNames);
