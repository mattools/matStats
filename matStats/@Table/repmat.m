function res = repmat(this, M, N)
%REPMAT Replicate and tile a data table
%
%   T2 = repmat(T, M, N)
%   T2 = repmat(T, [M N])
%   Overloads the behaviour fo repmat for objetc of class Table.
%
%
%   Example
%   repmat
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-07-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if nargin < 2
    error('Table:repmat:NotEnoughInputs', 'Requires at least 2 inputs.')
end

if nargin == 2
    if isscalar(M)
        N = M;
    else
        N = M(2);
        M = M(1);
    end
end

res = Table(...
    repmat(this.data, M, N), ...
    'colNames', repmat(this.colNames, 1, N), ...
    'rowNames', repmat(this.rowNames, M, 1), ...
    'name', this.name);

if hasFactors(this)
    res.levels = repmat(this.levels, 1, N);
end
