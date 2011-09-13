function tab = read(fileName, varargin)
%READ Read a datatable file
%
%   TABLE = Table.read(FILENAME);
%   Where FILENAME is the name of the file to read, returns a new data
%   table initialized with the content of the file.
%
%   TABLE = Table.read;
%   Without argument, the function opens a dialog to choose a data file,
%   and return the corresponding data table.
%
%   TABLE = Table.read(..., PARAM, VALUE);
%   Can specifiy parameters when reading the file. Available parameters
%   are:
%   'header' specifies if an header is present in the file. Can be true
%       (the default) or false.
%   'decimalPoint' a character to use when parsing numbers. Default is '.'.
%       When using a different value, lines will be analysed as text and
%       parsed, making the processing time longer. 
%   'delimiter' the set of characters used to delimitate values. Default
%       are ' \b\t' (space and tabulation).
%   'needParse' is a boolean used to force the parsing of numeric values.
%       If the decimal point is changed, parsing is automatically forced.
%   'rowNames' specifies index of the column containing the name of rows.
%       If set to 0, rows are numbered in natural ordering.
%
%
%   Example
%   
%
%   See also
%     textscan
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Initialisations

% if no file name is provided, open a dialog to choose a file
if nargin < 1
    [fileName path] = uigetfile(...
        {...
            '*.txt;*.TXT',  'Text Files (*.txt)'; ...
            '*.*',  'All Files (*.*)'}, ...
        'Choose a data table');
    fileName = fullfile(path, fileName);
end

% parse options and group into data structure
options = parseOptions(varargin{:});


%% Open file

% open file
f = fopen(fileName,'r');
if f == -1
	error('Couldn''t open the file %s', fileName);
end

% keep filename into data structure
[path name] = fileparts(fileName); %#ok<ASGLU>

% create empty data table
tab = Table();

% setup names
tab.name = name;
tab.fileName = fileName;

if strcmp(options.delim, options.whiteSpaces)
    delimOptions = {};
else
    delimOptions = {...
        'Delimiter', options.delim, ...
        'MultipleDelimsAsOne', true};
end
 

%% Read header

% Read the first line, which contains the name of each column
if options.header
    names = textscan(fgetl(f), '%s', delimOptions{:});
    tab.colNames = names{1}(:)';
end


%% Prepare reading data

% read the first data line
line = fgetl(f);

% count the number of strings in the first line
C1  = textscan(line, '%s', delimOptions{:});
C1  = C1{1};

% number of columns, and of data column
n   = length(C1);
nc  = n;

% if first variable is explicitely called 'name', use it for row names
if options.rowNamesIndex == -1
    if strcmp(tab.colNames{1}, 'name') || strcmp(tab.colNames{1}, 'nom')
        options.rowNamesIndex = 1;
    end
end

if options.rowNamesIndex > 0
    % number of data columns (remove one as first column contains row names)
    nc  = n - 1;

    % check column names have appropriate number
    if length(tab.colNames) > nc
        tab.colNames(options.rowNamesIndex) = [];
    end
end

% init levels
tab.levels = cell(1, nc);

% determines which columns are numeric
numeric = isfinite(str2double(C1));

if options.rowNamesIndex > 0
    numeric(options.rowNamesIndex) = false;
end

% compute appropriate format for reading all lines
formats = cell(1, n);
if options.needParse
    formats(:) = {' %s'};
else
    formats(numeric)    = {' %f'};
    formats(~numeric)   = {' %s'};
end
format = strtrim(strcat(formats{:}));

% convert values of first line to numeric
if ~options.needParse
    C1(numeric) = num2cell(str2double(C1(numeric)));
end


%% Read data

% read the rest of the file, in a Cell array (each cell is a column)
C = textscan(f, format, delimOptions{:});
fclose(f);

% concatenate first line with the rest 
for i = 1:length(C)
    C{i} = [C1{i} ; C{i}];
end

% number of rows
nr  = length(C{1});

% indices of columns that do not contain row names
inds = 1:n;

% store row names into data structure
if options.rowNamesIndex > 0
    tab.rowNames = C{options.rowNamesIndex};
    inds(options.rowNamesIndex) = [];
    
elseif ~isempty(options.rowNames)
    tab.rowNames = options.rowNames;
    
else
    % default row names are indices converted to cell array of chars
    tab.rowNames = strtrim(cellstr(num2str((1:nr)')));
    
end

% format data table
tab.data = zeros(nr, nc);


%% Format data

% fill up each column
for i = 1:length(inds)
    
    if numeric(inds(i)) && ~options.needParse
        tab.data(:, i) = C{inds(i)};
        
    else
        % current column
        col = C{inds(i)};

        % replace decimal separator by a dot
        col = strrep(col, options.decimalPoint, '.');

        % convert to numeric
        num = str2double(col);

        indNan = strcmpi(col, 'na') | strcmpi(col, 'nan');
        
        % if there are unconverted values, changes to factor levels
        if sum(isnan(num(~indNan))) == 0
            tab.data(:, i)  = num;
        else
            [levels I num]  = unique(col); %#ok<ASGLU>
            tab.data(:, i)  = num;
            tab.levels{i}   = levels;
        end
    end
end



function options = parseOptions(varargin)

% default values
options.rowNames        = {};
options.rowNamesIndex   = -1; % -1 for auto, 0 for no name, >=1 for index
options.decimalPoint    = '.';
options.whiteSpaces     = ' \b\t';
options.delim           = options.whiteSpaces;
options.header          = true;
options.needParse       = false;

% process each couple of argument, identifies the options, and set up the
% corresponding value in the result structure
while length(varargin)>1
    switch lower(varargin{1})
        case 'rownames'
            var = varargin{2};
            if ~iscell(var)
                % row names are given either as index or column name
                options.rowNamesIndex = var;
            else
                % row names are directly specified with cell array of names
                options.rowNamesIndex = var;
            end
        case 'header'
            options.header = varargin{2};
        case 'decimalpoint'
            options.decimalPoint = varargin{2};
            options.needParse = true;
        case {'delim', 'delimiter'}
            options.delim = varargin{2};
        case 'needparse'
            options.needParse = varargin{2};
        otherwise
            error('Table:read', ['unknown parameter: ' varargin{1}]);
    end
    varargin(1:2) = [];
end
