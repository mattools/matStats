function res = repmat(obj, M, N)
% Replicate and tile a data table.
%
%   T2 = repmat(T, M, N)
%   T2 = repmat(T, [M N])
%   Overloads the behaviour fo repmat for objects of class Table. M is the
%   number of repetitions along row axis, N is the number of repetitions
%   along column axis.
%
%
%   Example
%     % apply repmat on a simple table
%     tab = Table([1 2 3 ; 4 5 6], {'C1', 'C2', 'C3'});
%     tab22 = repmat(tab, 2, 2)
%     tab22 = 
%         C1    C2    C3    C1    C2    C3
%         --    --    --    --    --    --
%          1     2     3     1     2     3
%          4     5     6     4     5     6
%          1     2     3     1     2     3
%          4     5     6     4     5     6
%
%   See also
%     reshape
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-07-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% check input validity
if nargin < 2
    error('Table:repmat:NotEnoughInputs', 'Requires at least 2 inputs.')
end

% parse number of repetitions along each axis
if nargin == 2
    if isscalar(M)
        N = M;
    else
        N = M(2);
        M = M(1);
    end
end

% create result table
res = Table(...
    repmat(obj.Data, M, N), ...
    'ColNames', repmat(obj.ColNames, 1, N), ...
    'RowNames', repmat(obj.RowNames, M, 1), ...
    'Name', obj.Name);

% special processing of factor tables
if hasFactors(obj)
    res.Levels = repmat(obj.Levels, 1, N);
end
