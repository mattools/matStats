function res = power(obj, arg)
% Overload the power operator for Table objects.
%
%   output = power(input)
%
%   Example
%     power
%
%   See also
%     mpower, times
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

res = mpower(obj, arg);
