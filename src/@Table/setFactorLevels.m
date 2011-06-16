function setFactorLevels(this, colName, levels)
%SETFACTORLEVELS Set up the levels of a factor in a table
%
%   output = setFactorLevels(input)
%
%   Example
%   setFactorLevels
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

indCol = columnIndex(this, colName);

this.levels(indCol) = levels;
