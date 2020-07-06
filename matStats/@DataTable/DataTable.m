classdef (InferiorClasses = {?matlab.graphics.axis.Axes}) DataTable < Table
% Generic implementation of Table that manages factor columns.
%
%   Class DataTable
%
%   Example
%   DataTable
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-06,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
    % Factor levels, stored in a 1-by-Nc cell array. Each cell can be one
    % of the following:
    % * empty (column is not a factor), 
    % * a cell array of chars (column is a categorical factor), 
    % * an array of numeric values (colum is an ordered factor).
    % For columns considered as factor, the corresponding column in the
    % data array should only contain integer, whose maximum value should
    % not exceed the number of elements in the level cell.
    Levels;
    
    % The preferred plot type of each column. Should have as many elements
    % as the number of columns. Elements must be one of: {'line', 'stem',
    % 'stairStep', 'bar'}. Default is 'line'.
    PreferredPlotTypes;

end % end properties


%% Constructor
methods
    function obj = DataTable(varargin)
        % Constructor for DataTable class.
        %
        %   TAB = DataTable(DATA)
        %   where DATA is a numeric array, creates a new data table from a
        %   numeric array.
        %
        %   TAB = DataTable(..., 'ColNames', NAMES)
        %   Also specifies the name of columns. NAMES is a cell array with as
        %   many columns as the number of columns of the data table.
        %
        %   TAB = DataTable(..., 'RowNames', NAMES)
        %   Also specifies the name of rows. NAMES is a cell array with as many
        %   rows as the number of rows of the data table.
        %
        %   TAB = DataTable(..., 'Name', NAME)
        %   Also specify the name of the data table. NAME is a char array.
        %
        %   See Also
        %     Table/create
        %
        
        % special case of empty constructor
        if nargin == 0
            % empty constructor
            obj.Data = [];
            obj.RowNames = {};
            obj.ColNames = {};
            obj.Name = '';
            obj.Levels = {};
            obj.PreferredPlotTypes = {};
            return;
        end
        
        
        % ---------
        % Extract the data of the table
        
        var1 = varargin{1};
        if isa(var1, 'Table')
            % copy constructor
            tab = var1;
            obj.Data = tab.Data;
            obj.RowNames   = tab.RowNames;
            obj.ColNames   = tab.ColNames;
            obj.Name       = tab.Name;
            obj.Levels     = tab.Levels;
            obj.PreferredPlotTypes = tab.PreferredPlotTypes;
            
            varargin(1) = [];
            
        elseif (isnumeric(var1) || islogical(var1) || iscell(var1)) && size(var1, 2) == 1 && size(var1, 1) > 1
            % Each column is specified as a single column, with either
            % numeric or cell type
            
            % number of rows
            nRows = size(var1, 1);
            
            % determine the number of columns, by keeping all input args
            % with same size as first input arg.
            nCols = 1;
            for i = 2:length(varargin) 
                var = varargin{i};
                if (~ischar(var) && size(var, 2) ~= 1) || size(var, 1) ~= nRows
                    break;
                end
                nCols = nCols + 1;
            end
            
            % format data table
            obj.Data = zeros(nRows, nCols);
            obj.Levels = cell(1, nCols);
            
            % fill up each column
            for iCol = 1:nCols
                % current column
                % assume a numeric, char, or cell array as column vector
                col = varargin{iCol};
                
                if isnumeric(col) || islogical(col)
                    % all data are numeric
                    obj.Data(:, iCol)  = col;
                else
                    % convert char arrays to cell arrays
                    if ischar(col)
                        col = strtrim(cellstr(col));
                    end
                    
                    % character or cell array are used as factors
                    [levels, I, num]  = unique(col); %#ok<ASGLU>
                    obj.Data(:, iCol)  = num;
                    obj.Levels{iCol}   = levels;
                end
            end
            
            % remove processed input args.
            varargin(1:nCols) = [];
            
            % default column names
            obj.ColNames = strtrim(cellstr(num2str((1:nCols)')))';
            
            % populates the column names from input arguments
            for iCol = 1:nCols
                name = inputname(iCol);
                if ~isempty(name)
                    obj.ColNames{iCol} = name;
                end
            end
            
        elseif isnumeric(var1) || islogical(var1)
            % If first argument is numeric, assume obj is data array
            obj.Data = var1;
            varargin(1) = [];
            
        elseif iscell(var1)
            % create table from cell array.
            % The cell array can be either:
            % * a N-by-P cell array of N rows and P columns,
            % * a cell array of columns, each column being stored as an
            %   array.
            
            % extract data
            cellArray = var1;
            varargin(1) = [];
            
            % determine dimension of input array
            if size(cellArray, 1) == 1
                % first argument is either a column in a cell, or a cell
                % array containing the columns.
                nc = size(cellArray, 2);
                if nc == 1
                    % only one column is specified
                    % -> force the cell array encapsulation of the column
                    cellArray = {cellArray};
                end
                
                nr = size(cellArray{1}, 1);
                
            else
                % data specified as cell array of elements
                nc = size(cellArray, 2);
                nr = size(cellArray, 1);
                
                % convert 2D cell array to array of columns
                baseArray = cellArray;
                cellArray = cell(1, nc);
                for iCol = 1:nc
                    column = cell(nr, 1);
                    for iRow = 1:nr
                        column{iRow} = baseArray{iRow, iCol};
                    end
                    cellArray{iCol} = column;
                end
            end
            
            % format data table
            obj.Data = zeros(nr, nc);
            obj.Levels = cell(1, nc);
            
            % fill up each column
            for iCol = 1:nc
                % current column
                % assume a numeric, char, or cell array as column vector
                col = cellArray{iCol};
                
                if isnumeric(col) || islogical(col)
                    % all data are numeric
                    obj.Data(:, iCol)  = col;
                else
                    % convert char arrays to cell arrays
                    if ischar(col)
                        col = strtrim(cellstr(col));
                    end
                    
                    % character or cell array are used as factors
                    [levels, I, num]  = unique(col); %#ok<ASGLU>
                    obj.Data(:, iCol)  = num;
                    obj.Levels{iCol}   = levels;
                end
            end
        end
        
        
        % ---------
        % Parse row and col names
        
        % check if column names were specified
        if ~isempty(varargin)
            if iscell(varargin{1})
                if length(varargin{1}) ~= size(obj.Data,2)
                    error('Table:Table', ...
                        'Column names have %d elements, whereas table has %d columns', ...
                        length(varargin{1}), size(obj.Data,2));
                end
                obj.ColNames = varargin{1};
                varargin(1) = [];
            end
        end
        
        % check if row names were specified
        if ~isempty(varargin)
            var1 = varargin{1};
            if iscell(var1)
                if length(var1) ~= size(obj.Data,1) && ~isempty(var1)
                    error('Number of row names does not match row number');
                end
                obj.RowNames = var1;
                varargin(1) = [];
            end
        end
        
        
        % ---------
        % Process parent table if present
        
        if length(varargin) > 1
            ind = find(strcmpi(varargin(1:2:end), 'Parent'));
            if ~isempty(ind)
                % initialize new table with values from parent
                ind = ind * 2 - 1;
                parent = varargin{ind+1};
                obj.ColNames    = parent.ColNames;
                obj.RowNames    = parent.RowNames;
                obj.Name        = parent.Name;
                
                % copy properties specific to DataTable class
                if isa(parent, 'DataTable')
                    obj.Levels      = parent.Levels;
                    obj.PreferredPlotTypes = parent.PreferredPlotTypes;
                end
                
                % remove arguments from the list
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
            if strcmpi(param, 'RowNames')
                if ischar(value)
                    value = strtrim(cellstr(value));
                end
                if length(value) ~= size(obj.Data,1) && ~isempty(value)
                    error('Number of row names does not match row number');
                end
                obj.RowNames = value;
                
            elseif strcmpi(param, 'ColNames')
                if ischar(value)
                    value = strtrim(cellstr(value))';
                end
                if length(value) ~= size(obj.Data,2) && ~isempty(value)
                    error('Number of column names does not match column number');
                end
                obj.ColNames = value;
                
            elseif strcmpi(param, 'Name')
                obj.Name = value;
                
            elseif strcmpi(param, 'Levels')
                if length(value) ~= size(obj.Data,2)
                    error('Number of level does not match column number');
                end
                obj.Levels = value;
                
            elseif strcmpi(param, 'PreferredPlotTypes')
                if length(value) ~= size(obj.Data,2)
                    error('Number of values does not match column number');
                end
                obj.PreferredPlotTypes = value;
                
            else
                error('Table:Table', ...
                    ['Unknown parameter name: ' varargin{1}]);
            end
            
            varargin(1:2) = [];
        end
        
        
        % ---------
        % create default values for some fields if they were not initialised
        
        % size of the data table
        nc = size(obj.Data, 2);
        
        if isempty(obj.ColNames) && nc > 0
            obj.ColNames = strtrim(cellstr(num2str((1:nc)')))';
        end
        if isempty(obj.Levels) && nc > 0
            obj.Levels = cell(1, nc);
        end
        if isempty(obj.PreferredPlotTypes) && nc > 0
            obj.PreferredPlotTypes = repmat({'line'}, 1, nc);
        end
        
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

