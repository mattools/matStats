classdef Spectra < Table
% A list of spectra.
%
%   Class Spectra
%
%   Example
%     % Create an infrared spectrum list, using the "spectra" dataset.
%     load spectra;
%     xv = 900:2:1700;
%     sl = Spectra(NIR, xv);
%     plot(sl);
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
    % The positions of the spectra values on the x-axis.
    XValues;
    
    % The preferred plot type of the spectra. 
    % Must be one of: {'line', 'stem', 'stairStep', 'bar'}. Default is
    % 'line'. 
    PlotType = 'line';
    
    % The name of each of the axes, as a 1-by-Nd cell array (optionnal).
    AxisNames       = {};
    
    % Increasing X? can be 'normal' or 'reverse'
    XAxisDir = 'normal';
    
end % end properties

%% Declaration of static methods
methods (Static)
    tab = create(varargin)
%     tab = read(fileName, varargin)
end

%% Getters and Setters
methods
    function set.XValues(obj, values)
        % When changing the values, also change the column names.
        obj.XValues = values;
        obj.ColNames = cellstr(num2str(values'))';
    end
end


%% Constructor
methods
    function obj = Spectra(varargin)
        % Constructor for Spectra class.
        
        % special case of empty constructor
        if nargin == 0
            % empty constructor
            obj.Data = [];
            obj.XValues = {};
            obj.RowNames = {};
            obj.Name = '';
            return;
        end
        
        
        % ---------
        % Extract the data of the list of spectra
        
        var1 = varargin{1};
        if isa(var1, 'Spectra')
            % copy constructor
            tab = var1;
            obj.Data       = tab.Data;
            obj.XValues    = tab.XValues;
            obj.RowNames   = tab.RowNames;
            obj.Name       = tab.Name;
            obj.PlotType   = tab.PlotType;
            obj.XAxisDir   = tab.XAxisDir;
            varargin(1) = [];
      
        elseif isnumeric(var1)
            % If first argument is numeric, assume this is data array
            obj.Data = var1;
            varargin(1) = [];

        else
            error('Unable to parse first argument')
        end
        
        
        % ---------
        % Parse row and col names
        
        % check if column names were specified
        if ~isempty(varargin) && ~ischar(varargin{1})
            % check size
            var1 = varargin{1};
            if length(var1) ~= size(obj.Data,2)
                error('Spectra:Spectra', ...
                    'X Values have %d elements, whereas data has %d columns', ...
                    length(var1), size(obj.Data,2));
            end
            
            if isnumeric(var1)
                obj.XValues = var1;
                varargin(1) = [];
                
            elseif iscell(var1)
                % if second argument is cell string, assumes it contains
                % columns names with numeric values
                obj.XValues = str2num(char(var1'))'; %#ok<ST2NM>
                if isempty(obj.XValues)
                    error('Could not parse XValues from column names');
                end
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
        % Process parent data set if present
        
        if length(varargin) > 1
            ind = find(strcmp(varargin(1:2:end), 'Parent'));
            if ~isempty(ind)
                % initialize new table with values from parent
                ind = ind * 2 - 1;
                parent = varargin{ind+1};
                if isempty(obj.XValues)
                    obj.XValues     = parent.XValues;
                end
                if isempty(obj.RowNames)
                    obj.RowNames    = parent.RowNames;
                end
                obj.Name        = parent.Name;
                obj.PlotType    = parent.PlotType;
                
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
            if strcmpi(param, 'RowNames')
                if ischar(value)
                    value = strtrim(cellstr(value));
                end
                if length(value) ~= size(obj.Data,1) && ~isempty(value)
                    error('Number of row names does not match row number');
                end
                obj.RowNames = value;
                
            elseif strcmpi(param, 'XValues')
                if length(value) ~= size(obj.Data,2) && ~isempty(value)
                    error('Number of column names does not match column number');
                end
                obj.XValues = value;
                
            elseif strcmpi(param, 'ColNames')
                obj.ColNames = value;

            elseif strcmpi(param, 'Name')
                obj.Name = value;
                
            elseif strcmpi(param, 'PlotType')
                obj.PlotType = value;

            elseif strcmpi(param, 'XAxisDir')
                obj.XAxisDir = value;
                
            else
                error('Spectra:Spectra', ...
                    ['Unknown parameter name: ' varargin{1}]);
            end
            
            varargin(1:2) = [];
        end
        
        
        % ---------
        % create default values for some fields if they were not initialised
        
        % size of the data table
        nc = size(obj.Data, 2);
        
        if isempty(obj.XValues) && nc > 0
            obj.XValues = 1:nc;
        end
        if isempty(obj.PlotType) && nc > 0
            obj.PlotType = 'line';
        end
        
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

