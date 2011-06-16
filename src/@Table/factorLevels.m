function levels = factorLevels(this, colName)
%FACTORLEVELS List of the levels for a given factor
%
%   LEVELS = factorLevels(TAB, COLNAME)
%
%   Example
%   factorLevels
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


indFactor = columnIndex(this, colName);

if isempty(this.levels{indFactor})
    error('Column "%s" is not a factor', this.colNames{indFactor});
end

levels = this.levels{indFactor};
