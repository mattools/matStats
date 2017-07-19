function b = hasFactors(this)
%HASFACTORS Check if the table has column(s) representing factor(s)
%
%   B = hasFactors(TAB)
%   Returns true if at least one of the columns in the table contains
%   factors.
%
%   Example
%   hasFactors
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = sum(isFactor(this, 1:size(this.data, 2))) > 0;
