classdef Table < handle
%TABLE Class for data table with named rows and columns
%
%   output = Table(input)
%
%   Example
%   Table
%
%   See also
%
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
    
    % inner data of the table
    data;
    
    % name or rows
    rowNames;

    % name or columns
    colNames;
    
    % factor levels
    levels;
    
end

%% Declaration of static classes
methods (Static)
    tab = read(fileName, varargin)
end


%% Constructor
methods

    function this = Table(varargin)
        % Constructor for Table class
        
        if nargin==0
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
            this.name       = tab.name;
            
            varargin(1) = [];
            
        else
            % setup data
            this.data = varargin{1};
            
            % create default values for other fields
            nr = size(this.data, 1);
            this.rowNames = strtrim(cellstr(num2str((1:nr)')))';
            nc = size(this.data, 2);
            this.colNames = strtrim(cellstr(num2str((1:nc)')))';

            varargin(1) = [];
            
        end
 
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
        while length(varargin)>1
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
    end
    
end % constructor section


end %classdef