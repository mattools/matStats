function tab = create(data, varargin)
%CREATE Create a new data table
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
%   See also
%   read, write
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-04-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Setup data

if isstruct(data)
    % parses from data structure containing d, i and v fields
    nRows = length(data(:));
    names = fieldnames(data);
    nCols = length(names);

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
    
    tab = Table(dat);
    tab.colNames = names;
    tab.rowNames = strtrim(cellstr(num2str((1:nRows)')))';
    
else
    % first argument is assumed to contain data
    tab = Table(data, varargin{:});
    
end
    
% 
% %% Process parent table
% 
% if length(varargin) > 1
%     ind = find(strcmp(varargin(1:2:end), 'parent'));
%     if ~isempty(ind)
%         % initialize new table with values from parent
%         parent = varargin{ind+1};
%         tab.name        = parent.name;
%         tab.rowNames    = parent.rowNames;
%         tab.colNames    = parent.colNames;
%         tab.levels      = parent.levels;
%         
%         % remove argumets from the list
%         varargin(ind:ind+1) = [];
%     end
% end
% 
% 
% %% Process row and column names specified as cell arrays (deprecated)
% 
% % check if column names were specified
% if ~isempty(varargin)
%     if iscell(varargin{1})
%         tab.colNames = varargin{1};
%         varargin(1) = [];
%     end
% end
% 
% % check if row names were specified
% if ~isempty(varargin)
%     if iscell(varargin{1})
%         tab.rowNames = varargin{1};
%         varargin(1) = [];
%     end
% end
% 
% 
% %% Process other arguments
% 
% % other parameters can be set using parameter name-value pairs
% while length(varargin) > 1
%     % get parameter name and value
%     param = lower(varargin{1});
%     value = varargin{2};
%     
%     % switch
%     switch lower(param)
%         case 'rownames'
%             tab.rowNames = value;
%         case 'colnames'
%             tab.colNames = value;
%         case  'name'
%             tab.name = value;
%         case 'levels'
%             tab.levels = value;
%         otherwise
%             error('Table:create:UnknownParameter', ...
%                 ['Unknown parameter name: ' varargin{1}]);
%     end
%     
%     varargin(1:2) = [];
% end
% 
% 
% %% initialze empty fields
% 
% % initialize default row names
% if isempty(tab.rowNames)
%     nRows = size(tab.data, 1);
%     if nRows > 0
%         tab.rowNames = strtrim(cellstr(num2str((1:nRows)')))';
%     else
%         tab.rowNames = {};
%     end
% end
% 
% % initialize default column names
% if isempty(tab.colNames)
%     nCols = size(tab.data, 2);
%     if nCols > 0
%         tab.colNames = strtrim(cellstr(num2str((1:nCols)')))';
%     else
%         tab.colNames = {};
%     end
% end
% 
% % initialize levels
% if isempty(tab.levels)
%     tab.levels = cell(1, nCols);
% end

