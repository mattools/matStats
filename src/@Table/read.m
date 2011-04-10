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
%   'delim' the set of characters used to delimitate values. Default are
%       space and tabulation.
%   'needParse' is a boolean used to force the parsing of numeric values.
%       If the decimal point is changed, parsing is automatically forced.
%   
%   Example
%   
%
%   See also
%   
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Initialisations

% if no file name is provided, open a dialog to choose a file
if (nargin<1)
    [fileName path] = uigetfile(...
        {...
            '*.txt;*.TXT',  'Text Files (*.txt)'; ...
            '*.*',  'All Files (*.*)'}, ...
        'Choose a data table');
    fileName = fullfile(path, fileName);
end

% parse options
options = parseOptions(varargin{:});


%% Open file

% open file
f = fopen(fileName,'r');
if (f==-1)
	error('Couldn''t open the file %s', fileName);
end

% keep filename into data structure
[path name] = fileparts(fileName); %#ok<ASGLU>

tab = Table();
tab.name = name;
tab.fileName = fileName;


%% Read header

% Read the first line, which contains the name of each column
if options.header
    names = textscan(fgetl(f), '%s');
    tab.colNames = names{:}';
end


%% Prepare reading data

% read the first data line
line = fgetl(f);

% count the number of strings in the first line
C1  = textscan(line, '%s');
C1  = C1{1};
n   = length(C1);

% number of data columns (remove one as first column contains row names)
nc  = n-1;

% check column names have appropriate number
if length(tab.colNames)>nc
    tab.colNames(1) = [];
end

% init levels
tab.levels = cell(1, nc);

% determines which columns are numeric
numeric = isfinite(str2double(C1));

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
C = textscan(f, format);
fclose(f);

% concatenate first line with the rest 
for i=1:length(C)
    C{i} = [C1{i};C{i}];    
end

% number of rows
nr  = length(C{1});

% store row names into data structure
tab.rowNames = C{1};

% format data table
tab.data = zeros(nr, nc);


%% Format data

% fill up each column
for i=2:n
    if numeric(i) && ~options.needParse
        tab.data(:, i-1) = C{i};
    else
        % current column
        col = C{i};

        % replace decimal separator by a dot
        col = strrep(col, options.decimalPoint, '.');

        % convert to numeric
        num = str2double(col);

        indNan = strcmpi(col, 'na') | strcmpi(col, 'nan');
        
        % if there are unconverted values, changes to factor levels
        if sum(isnan(num(~indNan)))==0
            tab.data(:, i-1) = num;
        else
            [levels I num] = unique(col); %#ok<ASGLU>
            tab.data(:, i-1) = num;
            tab.levels{i-1} = levels;
        end
    end
end



function options = parseOptions(varargin)

% default values
options.decimalPoint    = '.';
options.sep             = ' \t';
options.header          = true;
options.needParse       = false;

% process each couple of argument, identifies the options, and set up the
% corresponding value in the result structure
while length(varargin)>1
    switch lower(varargin{1})
        case 'header'
            options.header = varargin{2};
        case 'decimalpoint'
            options.decimalPoint = varargin{2};
        case 'delim'
            options.delim = varargin{2};
        case 'needparse'
            options.needParse = varargin{2};
        otherwise
            error('Table:read', ['unknown parameter: ' varargin{1}]);
    end
    varargin(1:2) = [];
end
