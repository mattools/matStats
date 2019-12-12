function res = tail(obj, k)
% Show the last rows of a data table.
%
%   tail(TAB)
%   Display the last rows of a data table.
%
%   tail(TAB, K)
%   Specifies the number of rows to display
%
%   RES = tail(...)
%   returns the last rows in a new date table.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     tail(iris)
%     ans = 
%            SepalLength    SepalWidth    PetalLength    PetalWidth      Species
%     145            6.7           3.3            5.7           2.5    Virginica
%     146            6.7             3            5.2           2.3    Virginica
%     147            6.3           2.5              5           1.9    Virginica
%     148            6.5             3            5.2             2    Virginica
%     149            6.2           3.4            5.4           2.3    Virginica
%     150            5.9             3            5.1           1.8    Virginica
%
%   See also
%     head, disp, subsref
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-10-31,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

if nargin < 2
    k = 6;
else
    % Check that numrows is a non-negative integer scalar
    validateattributes(k, ...
        {'numeric'}, {'real', 'scalar', 'nonnegative', 'integer'}, ...
        'tail', 'k')
end

n = size(obj, 1);

if n < k
	res = obj;
else
    subs = struct('type', '()', 'subs', {{n-k+1:n, ':'}});
    res = subsref(obj, subs);
end
