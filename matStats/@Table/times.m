function res = times(obj, arg)
% Overload the times operator for Table objects.
%
%   RES = TAB1 .* TAB2;
%   RES = times(TAB1, TAB2);
%
%   Example
%   times
%
%   See also
%     mtimes, rdivide, power, plus, minus
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

res = mtimes(obj, arg);
