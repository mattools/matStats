function levels = factorLevels(obj, colName)
% List of the levels for a given factor.
%
%   LEVELS = factorLevels(TAB, COLNAME)
%   Returns the unique levels contained in the given column.
%
%   LEVELS = factorLevels(TAB)
%   When the table has only one column, it is not necessary to specify the
%   column name.
%
%   Example
%     % Display the different species in iris data table
%     iris = Table.read('fisherIris.txt');
%     factorLevels(iris, 'Species')
%     ans =
%         'Setosa'
%         'Versicolor'
%         'Virginica'
%
%     % alternative syntax:
%     factorLevels(iris('Species'))
%     ans =
%         'Setosa'
%         'Versicolor'
%         'Virginica'
%
%   See also
%     hasFactors, isFactor, trimLevels
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


if nargin < 2
    % assumes data table has only one column
    if size(obj.Data, 2) ~= 1
        error('Require either a column name, or a single column table');
    end
    
    indFactor = 1;
else
    % extract column index from column name, and check validity
    indFactor = columnIndex(obj, colName);
end

if isempty(obj.Levels{indFactor})
    error('Column "%s" is not a factor', obj.ColNames{indFactor});
end

% extract levels
levels = obj.Levels{indFactor};
