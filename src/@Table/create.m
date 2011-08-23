function tab = create(varargin)
%CREATE Create a new data table
%
%   TAB = Table.create(DATA)
%   where DATA is a numeric array, create a new data table initialized with
%   the array.
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
%   dat = rand(4, 3);
%   cols = {'col1', 'col2', 'col3'};
%   tab = Table.create(dat, 'colNames', cols);
%   tab.show();
%
%   See also
%   Table.read
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-04-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% setup data

% first argument is assumed to contain data
data = varargin{1};
tab = Table(data);
varargin(1) = [];

% create default values for other fields
if ~isa(data, 'Table')
    % row and column names
    nRows = size(tab.data, 1);
    tab.rowNames = strtrim(cellstr(num2str((1:nRows)')))';
    nCols = size(tab.data, 2);
    tab.colNames = strtrim(cellstr(num2str((1:nCols)')))';

    % initialize levels
    tab.levels = cell(1, nCols);
end


%% Process parent table

if length(varargin) > 1
    ind = find(strcmp(varargin(1:2:end), 'parent'));
    if ~isempty(ind)
        % initialize new table with values from parent
        parent = varargin{ind+1};
        tab.name        = parent.name;
        tab.rowNames    = parent.rowNames;
        tab.colNames    = parent.colNames;
        tab.levels      = parent.levels;
        
        % remove argumets from the list
        varargin(ind:ind+1) = [];
    end
end


%% Process row and column names specified as cell arrays (deprecated)

% check if column names were specified
if ~isempty(varargin)
    if iscell(varargin{1})
        tab.colNames = varargin{1};
        varargin(1) = [];
    end
end

% check if row names were specified
if ~isempty(varargin)
    if iscell(varargin{1})
        tab.rowNames = varargin{1};
        varargin(1) = [];
    end
end


%% Process other arguments

% other parameters can be set using parameter name-value pairs
while length(varargin) > 1
    % get parameter name and value
    param = lower(varargin{1});
    value = varargin{2};
    
    % switch
    switch lower(param)
        case 'rownames'
            tab.rowNames = value;
        case 'colnames'
            tab.colNames = value;
        case  'name'
            tab.name = value;
        case 'levels'
            tab.levels = value;
        otherwise
            error('Table:create:UnknownParameter', ...
                ['Unknown parameter name: ' varargin{1}]);
    end
    
    varargin(1:2) = [];
end


