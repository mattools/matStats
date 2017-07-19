function res = ctranspose(this)
%CTRANSPOSE Simple wrapper to transpose function to comply with ' syntax
%
%   output = ctranspose(input)
%
%   Example
%   Tab2 = Tab';
%
%   See also
%   transpose
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = transpose(this);
