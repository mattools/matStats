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


% first argument is assumed to contain data
data = varargin{1};
tab = Table(data);
varargin(1) = [];

% create default values for other fields
nRows = size(tab.data, 1);
tab.rowNames = strtrim(cellstr(num2str((1:nRows)')))';
nCols = size(tab.data, 2);
tab.colNames = strtrim(cellstr(num2str((1:nCols)')))';

% initialize levels
tab.levels = cell(1, nCols);


% check if column names were specified
if ~isempty(varargin)
    if iscell(varargin{1})
        this.colNames = varargin{1};
        varargin(1) = [];
    end
end

% check if row names were specified
if ~isempty(varargin)
    if iscell(varargin{1})
        this.rowNames = varargin{1};
        varargin(1) = [];
    end
end

% other parameters can be set using parameter name-value pairs
while length(varargin) > 1
    % get parameter name and value
    param = lower(varargin{1});
    value = varargin{2};
    
    % switch
    if strcmp(param, 'rownames')
        this.rowNames = value;
    elseif strcmp(param, 'colnames')
        this.colNames = value;
    elseif strcmp(param, 'name')
        this.name = value;
    else
        error('Table:Table', ...
            ['Unknown parameter name: ' varargin{1}]);
    end
    
    varargin(1:2) = [];
end


