function clearFactors(this)
%CLEARFACTORS Replace all factor columns by numeric columns
%
%   clearFactors(TAB)
%   This functions replaces all factor columns by numeric columns. 
%
%   Example
%   clearFactors
%
%   See also
%     setAsFactor, setFactorLevels
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nv = size(this.Data, 2);
this.levels = cell(1, nv);
