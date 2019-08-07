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
% e-mail: david.legland@inra.fr
% Created: 2012-10-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % the name of the original data table
    TableName = '';
    
    % the name of the variable (name of the first column of the table)
    VarName = '';
    
    PValues;
    Table;
    Stats;
    Terms;
    
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
            this.TableName  = data.TableName;
            this.VarName    = data.VarName;
            this.PValues    = data.PValues;
            this.TableName  = data.TableName;
            this.Stats      = data.Stats;
            this.Terms      = data.Terms;
        end

        % extract input data
        if isa(data, 'Table')
            dataValues = data.Data;
            this.TableName = data.Name;
            this.VarName = data.ColNames{1};
            
        else
            % if data are numeric, assumes groups is Table object
            dataValues = data;
            this.VarName = inputname(1);
        end
        
        % extract group values
        groupNames = {};
        if isa(groups, 'Table')
            groupNames = groups.ColNames;
            
            % create a new groupValues populated with level names
            nGroups = columnNumber(groups);
            groupValues = cell(1, nGroups);
            for i = 1:nGroups
                vals = groups.Data(:, i);
                if isFactor(groups, i)
                    % use cell array of strings for this group
                    levelNames = groups.Levels{i};
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
        [this.PValues, this.TableName, this.Stats, this.Terms] = ...
            anovan(dataValues, groupValues, ...
            'varnames', groupNames, ...
            varargin{:});

    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

