function [p, table, stats, terms] = anova(data, groups, varargin)
%ANOVAN Multi-way analysis of variance
%
%   anovan(DATA, groups)
%   At least DATA or groups should be a data table with one column, the
%   other argument, must be a data table or a column vector the same size.
%   The functions formats inputs, and call the "anovan" function in the
%   statistics toolbox.
%
%   anovan(..., NAME, VALUE)
%   Specifies additional parameters that will be passed to the anovan
%   function.
%
%   [p table stats terms] = anovan(...)
%   Returns additionnal results, that can be used with the 'multcompare'
%   function.
%
%   Example
%   anovan
%
%   See also
%     multcompare
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract input data
if isa(data, 'Table')
    dataValues = data.data;
    
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
[p, table, stats, terms] = anovan(dataValues, groupValues, ...
    'varnames', groupNames, ...
    varargin{:});

