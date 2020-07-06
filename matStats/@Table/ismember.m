function res = ismember(obj, values)
% Override the ismember function.
%
%   RES = ismember(TAB, VALS)
%   Returns a data table with same number of rows and columns as the input
%   table, containing boolean depending on whether the corresponding data
%   are member of the specified value(s).
%
%   Example
%     % find items with specified numerical values
%     tab = Table(magic(3));
%     ismember(tab, [1 2 3])
%     ans = 
%              1    2    3
%         1    0    1    0
%         2    1    0    0
%         3    0    0    1
%
%     % compare factor levels with cell array of strings
%     iris = Table.read('fisherIris.txt');
%     res = ismember(iris('Species'), {'Versicolor', 'Virginica'});
%     [iris(48:53, 'Species') res(48:53, :)]
%     ans = 
%                     Species    ismember(Species,vals)
%        48            Setosa                         0
%        49            Setosa                         0
%        50            Setosa                         0
%        51        Versicolor                         1
%        52        Versicolor                         1
%        53        Versicolor                         1
% 
%   See also
%     find, cellstr, eq, ne
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if isnumeric(values)
    % simple case: no factor
    dat = ismember(obj.Data, values);
    res = Table.create(dat, 'Parent', obj);

else
    % can compare levels of a single factor column. 
    % need to convert to cell array of levels.
    
    % ensure single column
    if size(obj, 2) > 1
        error('can process cell array with only one column');
    end
    
    % use ismember on the corresponding cell array
    cells = cellstr(obj);
    
    % create resulting array
    res = Table.create(ismember(cells, values));
    res.ColNames = {sprintf('ismember(%s,vals)', obj.ColNames{1})};
    res.RowNames = obj.RowNames;
end
