function write(obj, fileName, varargin)
% Write a datatable into a file.
%
%   write(TAB, FILENAME)
%   writes the content of the data table TAB into the file given by name
%   FILENAME.
%
%   write(TAB, FORMAT);
%   write(TAB, 'format', FORMAT);
%   Also provides writing format for variable. FORMAT is a string
%   containing series of C-language based formatting tags, such as:
%   '%5.3f %3d %6.4f %02d %02d'. Number of formatting tags must equal the
%   number of columns in data table.
%   FORMAT can also end with '\n', and begin with '%s '. Following formats
%   are equivalent for tableWrite:
%   '%5.2f %3d %3d'
%   '%s %5.2f %3d %3d'
%   '%5.2f %3d %3d\n'
%   '%s %5.2f %3d %3d\n'
%
%   write(..., NAME, VALUE)
%   Specifies one or several parameters using name-value pairs. Available
%   parameters are:
%
%   'Format'        as described above
%
%   'WriteLevels'   boolean indicating whether factor columns must be saved
%       as numeric values (value = FALSE) or as character strings (value =
%       TRUE). Default is TRUE if the 'ColNames' property is not empty.
%
%   'WriteRowNames' boolean indicating whether the name of each row should
%       be written in the beginning of each line. Default is TRUE if the
%       'RowNames' property is not empty.
%
%   'WriteHeader'   boolean indicating whether the header line should be
%       written or not. Default is TRUE.
%
%   'Separator'     character string that is used for separating different
%       values in the file. Default is ' '. If a different value is
%       specified, it is used also for separating header names.
%
%   'HeaderSeparator'     character string used for separating column names
%       in the first line of the file. Default is '   '.
%
%
%   Example
%     tab = Table.create([5.2 6.7;8.1 7.8;5.3 8.1], ...
%       'colNames', {'var1', 'var2'});
%     write(tab, 'demoWrite.txt');
%     type demoWrite.txt
%
%
%   See also
%     read, printLatex
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% process input

% default values of parameters
format = [];
writeHeader = ~isempty(obj.ColNames);
writeRowNames = ~isempty(obj.RowNames);
writeLevels = hasFactors(obj) ;
sep = ' ';
headerSep = '   ';

% extract value of optional parameters
while length(varargin) > 1
    var = lower(varargin{1});
    switch var
        case 'format'
            format = varargin{2};
        case 'writelevels'
            writeLevels = varargin{2};
        case 'writerownames'
            writeRowNames = varargin{2};
        case 'writeheader'
            writeHeader = varargin{2};
        case 'separator'
            sep = varargin{2};
            headerSep = sep;
        case 'headerseparator'
            headerSep = varargin{2};
        otherwise
            error(['Unknown parameter: ' varargin{1}]);
    end
    varargin(1:2) = [];
end

% extract format if there only one argument left
if ~isempty(varargin)
    format = varargin{1};
end


%% Compute the formatting string

% number of row and columns
nRows = size(obj.Data, 1);
nCols = size(obj.Data, 2);

% if need to write row names without valid row names, ensure valid ones.
if writeRowNames
    rowNames = consolidatedRowNames(obj);
end

% compute default format string for writing data, if not given as argument
if isempty(format)
    format = ['%g' repmat([sep '%g'], 1, nCols-1) '\n'];
end

% check which columns are factors, and update format string accordingly
if writeLevels
    % first check that table has a valid number of levels
    nLevels = length(obj.Levels);
    if nLevels == 0 && nLevels ~= nCols
        error('Table:write', ...
            'Number of levels in table should match number of columns');
    end
     
    % extract format tokens
    formats = textscan(format, '%s', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
    formats = formats{1};
    
    % use flag
    useRowNamesFormat = length(formats) > nCols;
        
    % for each factor column, replace numeric format by string format
    isFactorFlag = isFactor(obj, 1:nLevels);
    inds = find(isFactorFlag);
    for i = 1:length(inds)
        % current format
        colFormat = formats{inds(i) + useRowNamesFormat};
        
        % check if replacement is needed
        if colFormat(end) == 's'
            continue;
        end
        
        % compute max length of level names
        n = -1;
        levels = obj.Levels{inds(i)}; 
        for j = 1:length(levels)
            n = max(n, length(levels{j}));
        end

        % update with string format
        colFormat = {['%' num2str(n) 's']};
        formats(inds(i) + useRowNamesFormat) = colFormat;
    end
    
    % create new format string
    format = formats{1};
    for i = 2:length(formats)
        format = [format sep formats{i}]; %#ok<AGROW>
    end
end


%% Ensure the format string is valid

% check the presence of '%s' in the beginning, and '\n' at the end

% count number of tokens
tokens = textscan(format, '%s', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
nTokens = length(tokens{1});

% If only one formatting argument is given, it is repeated by the number of
% columns
if nTokens == 1 && nCols > 1
    format = strtrim(format);
    format = [format repmat([sep format], 1, nCols - 1)];
    nTokens = nCols;
end

% add '%s ' in the beginning if missing
if nTokens ~= nCols + 1 && writeRowNames
    len = max(cellfun(@length, rowNames));
    format = ['%-' int2str(len) 's' sep format];
end

% add '\n' if missing
if ~strcmp(format(end-1:end), '\n')
    format = [format '\n'];
end


%% Write into file

% open file for writing text
f = fopen(fileName, 'wt');
if (f == -1)
	error('Couldn''t open the file %s', fileName);
end

% write the header line
if writeHeader
    % write the names of the columns, separated by spaces
    pattern = ['%s' repmat([headerSep '%s'], 1, nCols-1) '\\n'];
    str = sprintf(pattern, obj.ColNames{:});

    % optionnally adds column name for row names
    if writeRowNames
        str = ['name' headerSep str];
    end
    
    % print header to file
    fprintf(f, str);
end

% write each row of data
if ~writeLevels
    % write data as numeric
    if writeRowNames
        for i = 1:nRows
            fprintf(f, format, rowNames{i}, obj.Data(i, :));
        end
    else
        for i = 1:nRows
            fprintf(f, format, obj.Data(i, :));
        end
    end
    
else
    % some columns are levels, so we need to format text
    data = cell(1, nCols);
    for i = 1:nRows
        % fill up levels
        for j = 1:length(inds)
            data{inds(j)} = obj.Levels{inds(j)}{obj.Data(i, inds(j))};
        end
        % fill up numeric values
        if sum(~isFactorFlag) > 0
            data(~isFactorFlag) = num2cell(obj.Data(i, ~isFactorFlag));
        end
        
        % write current row
        if writeRowNames
            fprintf(f, format, rowNames{i}, data{:});
        else
            fprintf(f, format, data{:});
        end
    end
end

% close the file
fclose(f);
