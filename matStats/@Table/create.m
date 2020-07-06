function tab = create(data, varargin)
% Create a new data table.
%
%   TAB = Table.create(DATA)
%   where DATA is a numeric array, creates a new data table initialized
%   with the content of the array.
%
%   TAB = Table.create(STRUCTARRAY)
%   where STRUCTARRAY is a N-by-1 or 1-by-N vector of structures, creates a
%   new table whose rows correspond to the structures, and columns
%   correspond to the structure fields. Column names are initialised with
%   the field names.
%   Does not support nested fields.
%
%   TAB = Table.create(..., 'colNames', NAMES)
%   Also specifies the name of columns. NAMES is a cell array with as many
%   columns as the number of columns of the data table. 
%
%   TAB = Table.create(..., 'rowNames', NAMES)
%   Also specifies the name of rows. NAMES is a cell array with as many
%   columns as the number of rows of the data table.
%
%   TAB = Table.create(..., 'name', NAME)
%   Also specify the name of the data table. NAME is a char array.
%
%   Example
%     % create data table with direct initialization of the fields
%     dat = rand(4, 3);
%     cols = {'col1', 'col2', 'col3'};
%     tab = Table.create(dat, 'colNames', cols);
%     tab.show();
%
%     % create data table from structure array obtained with regionprops
%     lbl = bwlabel(imread('coins.png') > 100);
%     props = regionprops(lbl, {'Area', 'EquivDiameter', 'Eccentricity'});
%     tab = Table.create(props);
%     scatter(tab, 'Area','EquivDiameter', 'o');
%
%     % create data table from structure array containing each column
%     s = load('carsmall');
%     tab = Table.create(s);
%     tab(1:5, 2:end)
%     ans = 
%              Origin    MPG    Cylinders    Displacement    Horsepower    Weight    Acceleration    Model_Year          Mfg
%     1           USA     18            8             307           130      3504              12            70    chevrolet
%     2           USA     15            8             350           165      3693            11.5            70        buick
%     3           USA     18            8             318           150      3436              11            70     plymouth
%     4           USA     16            8             304           150      3433              12            70          amc
%     5           USA     17            8             302           140      3449            10.5            70         ford
% 
%
%   See also
%   Table, read, write
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-04-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Setup data

if isstruct(data) 
    if length(data) > 1
        % parses from an array structures
        % -> as many rows as the number of struct in the array
        % -> each field is associated to a column
        
        % compute size of table
        nRows = length(data(:));
        names = fieldnames(data);
        nCols = length(names);
        
        % initialize the table data
        dat = zeros(nRows, nCols);
        for i = 1:nRows
            for j = 1:nCols
                var = data(i).(names{j});
                if ~isnumeric(var) || ~isscalar(var)
                    error('Requires structure with scalar numeric fields');
                end
                dat(i, j) = var;
            end
        end
        
        % create data table
        rowNames = strtrim(cellstr(num2str((1:nRows)')))';
        tab = DataTable(dat, names, rowNames);
        
    else
        % only one struct
        % -> each field is associated to a column
        % -> all fields are assumed to have the same length
        
        % compute size of table
        names = fieldnames(data);
        nCols = length(names);
        
        % check all fields have the same size
        nRows = length(data.(names{1}));
        for iCol = 1:nCols
            name = names{iCol};
            var = data.(name);
            
            % determine number of rows of current column
            n = size(var, 1);
            
            if iCol == 1
                nRows = n;
                continue;
            end
            
            if n ~= nRows
                error(sprintf(...
                    'Field %s do not have same number of rows as field %d', ...
                    name, names{1})); %#ok<SPERR>
            end
        end
        
        % allocate memory
        dat = zeros(nRows, nCols);
        colNames = cell(1, nCols);
        levels = cell(1, nCols);
        
        % iterate over columns
        for iCol = 1:nCols
            name = names{iCol};
            colNames{iCol} = name;
            
            var = data.(name);
            if isnumeric(var)
                dat(:, iCol) = var;
            else
                if ischar(var)
                    var = strtrim(cellstr(var));
                end
                
                % transform cell array into data column
                [values, I, J] = unique(var); %#ok<ASGLU>
                dat(:, iCol) = J;
                levels{iCol} = values;
            end
        end
        
        % create data table
        tab = DataTable(dat, names, 'Levels', levels);
    end
    
elseif iscell(data)
    
else
    % first argument is assumed to contain data
    tab = DataTable(data, varargin{:});
    
end
    
