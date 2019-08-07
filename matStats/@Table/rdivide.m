function res = rdivide(this, arg)
%RDIVIDE Overload the rdivide operator for Table objects
%
%   output = rdivide(input)
%
%   Example
%   rdivide
%
%   See also
%     rtimes, mrdivides
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

res = mrdivide(this, arg);
