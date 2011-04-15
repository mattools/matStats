function s = size(this, varargin)
%SIZE Size of a data table
%
%   S = size(TAB)
%   S = TAB.size()
%   Returns the size of the data table TAB. S is a row vector containing
%   the number of rows and the number of columns in the table.
%
%   Example
%   size
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-04-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

s = [rowNumber(this) columnNumber(this)];
