classdef Table < handle
%TABLE Class for data table with named rows and columns
%
%   Creation:
%   tab = Table(DATA);
%   tab = Table(DATA, 'rowNames', ROWNAMES, 'colNames', COLNAMES);
%   Create data table from a numeric array, with possibility to specify
%   values of some parameters. See Table/Table.
%
%   tab = Table.read(FILENAME);
%   Read the content of a data table from a text file.
%
%   Display info:
%   tab.plot(COLNAME);
%   tab.scatter(COLUMN1, COLUMN2);
%
%   Example
%   Table
%
%   See also
%   Table.create, Table.read
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % the name of the table
    name;
    
    % the name of the file used for initializing the Table
    fileName;
    
    % inner data of the table, stored in a Nr-by-Nc array of double
    data;
    
    % name of columns, stored in a 1-by-Nc cell array of strings
    colNames;
    
    % name of rows, stored in a Nr-by-1 cell array of strings
    rowNames;

    % factor levels, stored in a 1-by-Nc cell array. Each cell can be empty
    % (column is not a factor), a cell array of chars (column is a
    % categorical factor), or an array of numeric values (colum is an
    % ordered factor).
    levels;
    
end

%% Declaration of static classes
methods (Static)
    tab = create(varargin)
    tab = read(fileName, varargin)
    varargout = concatFiles(inputFiles, outputFile, varargin)
end


%% Constructor
methods

    function this = Table(varargin)
    %Constructor for Table class
    %
    %   TAB = Table(DATA)
    %   where DATA is a numeric array, create a new data table from a
    %   numeric array.
    %
    %   TAB = Table(..., 'colNames', NAMES)
    %   Also specifies the name of columns. NAMES is a cell array with as
    %   many columns as the number of columns of the data table. 
    %
    %   TAB = Table(..., 'rowNames', NAMES)
    %   Also specifies the name of rows. NAMES is a cell array with as many
    %   rows as the number of rows of the data table. 
    %
    %   TAB = Table(..., 'name', NAME)
    %   Also specify the name of the data table. NAME is a char array.
    %  
    %   See Also
    %   Table/create
    %


        % ---------
        % Analyse the first argument, if present
        
        if nargin == 0
            % empty constructor
            this.data = [];
            this.rowNames = {};
            this.colNames = {};
            
        elseif isa(varargin{1}, 'Table')
            % copy constructor
            tab = varargin{1};
            this.data = tab.data;
            this.rowNames   = tab.rowNames;
            this.colNames   = tab.colNames;
            this.levels     = tab.levels;
            this.name       = tab.name;
            
            varargin(1) = [];
            
        elseif isnumeric(varargin{1}) || islogical(varargin{1})
            % If first argument is numeric, assume this is data array
            this.data = varargin{1};
            varargin(1) = [];
            
        end
 
        
        % ---------
        % Parse row and col names
        
        % check if column names were specified
        if ~isempty(varargin)
            if iscell(varargin{1})
                if length(varargin{1}) ~= size(this.data,2)
                    error('Column names have %d elements, whereas table has %d columns', ...
                        length(varargin{1}), size(this.data,2));
                end
                this.colNames = varargin{1};
                varargin(1) = [];
            end
        end
        
        % check if row names were specified
        if ~isempty(varargin)
            if iscell(varargin{1})
                if length(varargin{1}) ~= size(this.data,1)
                    error('Number of row names does not match row number');
                end
                this.rowNames = varargin{1};
                varargin(1) = [];
            end
        end

        
        % ---------
        % Process parent table if present
        
        if length(varargin) > 1
            ind = find(strcmp(varargin(1:2:end), 'parent'));
            if ~isempty(ind)
                % initialize new table with values from parent
                ind = ind * 2 - 1;
                parent = varargin{ind+1};
                this.name        = parent.name;
                this.rowNames    = parent.rowNames;
                this.colNames    = parent.colNames;
                this.levels      = parent.levels;
                
                % remove argumets from the list
                varargin(ind:ind+1) = [];
            end
        end

        
        % ---------
        % parse additional arguments set using parameter name-value pairs
        
        while length(varargin) > 1
            % get parameter name and value
            param = lower(varargin{1});
            value = varargin{2};
            
            % switch
            if strcmp(param, 'rownames')
                if length(value) ~= size(this.data,1)
                     error('Number of row names does not match row number');
                end
                this.rowNames = value;
                    
            elseif strcmp(param, 'colnames')
                if length(value) ~= size(this.data,2)
                     error('Number of column names does not match column number');
                end
                this.colNames = value;

            elseif strcmp(param, 'levels')
                if length(value) ~= size(this.data,2)
                     error('Number of level does not match column number');
                end
                this.levels = value;
            
            elseif strcmp(param, 'name')
                this.name = value;
            
            else
                error('Table:Table', ...
                    ['Unknown parameter name: ' varargin{1}]);
            end
            
            varargin(1:2) = [];
        end
       
            
        % ---------
        % create default values for other fields if they're not initialised

        % size if the data table            
        nr = size(this.data, 1);
        nc = size(this.data, 2);
        
        if isempty(this.rowNames) && nr > 0
            this.rowNames = strtrim(cellstr(num2str((1:nr)')));
        end
        if isempty(this.colNames) && nc > 0
            this.colNames = strtrim(cellstr(num2str((1:nc)')))';
        end
        if isempty(this.levels) && nc > 0
            this.levels = cell(1, nc);
        end    

    end
    
end % constructor section


end %classdef
