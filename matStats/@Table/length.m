function l = length(this)
%LENGTH Number of rows in the table.
%
%   L = length(TAB)
%   Returns the number of rows (observations) in the data table TAB.
%   This is equivalent to the function size(TAB, 1);
%
%   See also
%     size, ndims
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-23,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

l = size(this.Data, 1);
