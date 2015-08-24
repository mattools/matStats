classdef Anova < handle
%ANOVA Analysis of variance of a data table
%
%   RES = Anova(TAB, GROUP);
%   Applies analysis of variance on the column given by TAB, and the groups
%   given by GROUP. 
%
%   Example
%     % Analysis of variance on Fisher's iris
%     iris = Table.read('fisherIris');
%     res = Anova(iris('SepalLength'), iris('Species'));
%
%   See also
%   anovan, multcompare

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2012-10-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % the name of the original data table
    tableName;
    
    p;
    table;
    stats;
    terms;
    
end % end properties


%% Constructor
methods
    function this = Anova(data, groups, varargin)
    % Constructor for Anova class

        % check presence of stats toolbox
        if isempty(ver('stats'))
            error('Requires the statistics toolbox');
        end

        % copy constructor
        if isa(data, 'Anova')
            this.tableName  = data.tableName;
            this.p = data.p;
            this.table = data.table;
            this.stats = data.stats;
            this.terms = data.terms;

        end
        
        %% Parse input arguments
             
        % extract input data
        if isa(data, 'Table')
            dataValues = data.data;
            this.tableName = data.name;
            
        else
            % if data are numeric, assumes groups is Table object
            dataValues = data;
        end
        
        % extract group values
        groupNames = {};
        if isa(groups, 'Table')
            groupNames = groups.colNames;
            
            % create a new groupValues populated with level names
            nGroups = columnNumber(groups);
            groupValues = cell(1, nGroups);
            for i = 1:nGroups
                vals = groups.data(:, i);
                if isFactor(groups, i)
                    % use cell array of strings for this group
                    levelNames = groups.levels{i};
                    groupValues{i} = levelNames(vals);
                    
                else
                    % use numeric array for this group
                    groupValues{i} = vals;
                end
            end
            
        else
            % if groups is an array, keep it the same
            groupValues = groups;
            
        end
        
        % call the function from statistic toolbox with appropriate parameters
        [this.p, this.table, this.stats, this.terms] = ...
            anovan(dataValues, groupValues, ...
            'varnames', groupNames, ...
            varargin{:});

    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

