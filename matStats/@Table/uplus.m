function res = uplus(obj)
% Overload the uplus operator for Table objects.
%
%   output = uplus(input)
%
%   Example
%   uplus
%
%   See also
%     uminus, plus
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

newData = builtin('uplus', obj.Data);
res = Table.create(newData, 'Parent', obj);
