function setAsFactor(this, colName, varargin)
%SETASFACTOR Set the given column as a factor
%
%   setAsFactor(TAB, COLNAME)
%   Specifies that the given column(s) should be considered as a factor.
%   COLNAME is either the index or the name of the column that should be
%   considered as a factor.
%   If COLNAME is a row vector of indices, or a cell array of column names,
%   all the specified columns will be treated as factors.
%
%   Example
%     VALS = [10.12 10.23 9.83 10.53 9.98 10.81]';
%     GRP = [1 1 1 2 2 2]';
%     TAB = Table([VALS GRP], {'values', 'group'});
%     TAB.setAsFactor('group');
%     TAB.setFactorLevels('group', {'original', 'modified'}');
%     TAB
%     TAB = 
%              values       group
%     1         10.12    original
%     2         10.23    original
%     3          9.83    original
%     4         10.53    modified
%     5          9.98    modified
%     6         10.81    modified
%
%   See also
%     isFactor, setFactorLevels, combineFactors
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
    
    % if factors are already set, show warning and switch to next column
    if ~isempty(this.levels{indi})
        warning('Table:setAsFactor:AlreadySetFactor', ...
            'Column "%s" is already set as factor', this.colNames{indi});
        continue;
    end
    
    % extract unique values
    [levels, I, J] = unique(this.data(:, indi)); %#ok<ASGLU>
    
    % convert to cell array of strings
    levels = strtrim(cellstr(num2str(unique(levels))));
    
    % set up levels of data tables
    this.levels{indi} = levels;
    this.data(:, indi) = J;
end
