function res = mpower(this, arg)
%MPOWER Overload the mpower operator for Table objects
%
%   output = mpower(input)
%
%   Example
%   mpower
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if isa(arg, 'Table')
    arg = arg.data;
end

newData = bsxfun(@power, this.data, cast(arg, class(this.data)));

res = Table.create(newData, 'parent', this);
