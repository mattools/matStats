function res = head(obj, k)
% Show the first rows of a data table.
%
%   head(TAB)
%   Display the first rows of a data table.
%
%   head(TAB, K)
%   Specifies the number of rows to display
%
%   RES = head(...)
%   returns the first rows in a new date table.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     head(iris)
%     ans = 
%          SepalLength    SepalWidth    PetalLength    PetalWidth    Species
%     1            5.1           3.5            1.4           0.2     Setosa
%     2            4.9             3            1.4           0.2     Setosa
%     3            4.7           3.2            1.3           0.2     Setosa
%     4            4.6           3.1            1.5           0.2     Setosa
%     5              5           3.6            1.4           0.2     Setosa
%     6            5.4           3.9            1.7           0.4     Setosa
%
%
%   See also
%     tail, disp, subsref
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
        'head', 'k')
end

n = size(obj, 1);

if n < k
	res = obj;
else
    subs = struct('type', '()', 'subs', {{1:k, ':'}});
    res = subsref(obj, subs);
end
