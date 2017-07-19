function res = uplus(this)
%UPLUS  Overload the uplus operator for Table objects
%
%   output = uplus(input)
%
%   Example
%   uplus
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

newData = builtin('uplus', this.data);
res = Table.create(newData, 'parent', this);
