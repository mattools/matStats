function res = uminus(obj)
% Overload the uminus operator for Table objects.
%
%   output = uminus(input)
%
%   Example
%   uminus
%
%   See also
%     minus, plus
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-02-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

newData = builtin('uminus', obj.Data);

res = Table.create(newData, 'Parent', obj);
