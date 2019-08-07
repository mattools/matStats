function inds = subsindex(this)
%SUBSINDEX Overload the subsindex method for Table objects
%
%   output = subsindex(input)
%
%   Example
%   subsindex
%
%   See also
%     find, subsref

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

inds = find(this.Data) - 1;