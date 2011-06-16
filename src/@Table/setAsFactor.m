function setAsFactor(this, colName, varargin)
%SETASFACTOR Set the given column as a factor
%
%   setAsFactor(TAB, COLNAME)
%   Specifies that the given column should be considered as a factor.
%
%   Example
%   setAsFactor
%
%   See also
%   Table/isFactor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract index (or indices) of column(s)
ind = columnIndex(this, colName);

% convert each specified column as factor
for i = 1:length(ind)
    indi = ind(i);
    
    % if factors are already set, show warning
    if ~isempty(this.levels{indi})
        warning('Table:setAsFactor:AlreadySetFactor', ...
            'Column "%s" is already set as factor', this.colNames{indi});
    end
    
    % extract unique values
    [levels I J] = unique(this.data(:, indi)); %#ok<ASGLU>
    
    % convert to cell array of strings
    levels = strtrim(cellstr(num2str(unique(levels))));
    
    % set up levels of data tables
    this.levels{indi} = levels;
    this.data(:, indi) = J;
end
