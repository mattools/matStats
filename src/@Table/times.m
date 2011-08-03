function res = times(this, arg)
%TIMES  Overload the times operator for Table objects
%
%   output = mtimes(input)
%
%   Example
%   times
%
%   See also
%   mtimes, rdivide, power
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

res = mtimes(this, arg);
