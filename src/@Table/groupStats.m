function res = groupStats(this, varargin)
%GROUPSTATS Compute descriptive stats for each level of a factor column
%
%   RES = groupStats(TAB, COLNAME, FACTORNAME)
%   TAB is a data table with several columns, COLNAME is the index or the
%   name of the colun containing values, FACTORNAME is the index or the
%   name of the column containing the factor.
%
%   RES = groupStats(TAB, FACT)
%   TAB is a data table with only one column, FACT is either a numeric
%   vector, a char array, or a data table with one column.
%
%   The function extracts levels of the factor input, and computes a set of
%   descriptive statistics for the input values coresponding to this level.
%
%   Example
%   groupStats
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


groupNames = {}; 

if columnNumber(this) == 1
    % data are all given in first input
    
    % need to specify at least one other input
    if nargin < 2
        error('Need to specify the grouping variable');
    end
    
    values = this.data;
    name = this.colNames{1};

    % second input represents groups
    var = varargin{1};
    if isa(var, 'Table')
        valuesGroup = var.data(:, 1);
        if isFactor(var, 1)
            groupNames = factor.levels{1};
        end
        factorName = var.colNames{1};
        
    else
        valuesGroup = var;
        factorName = '??';
    end
    
else
    % need to specify at least two other inputs
    if nargin < 3
        error('Need to specify names of data and grouping variables');
    end

    % parse index of column containing data
    indValues = columnIndex(this, varargin{1});
    values = this.data(:, indValues(1));
    name = this.colNames{indValues(1)};

    % parse index of grouping variable
    indGroups = columnIndex(this, varargin{2});
    valuesGroup = this.data(:, indGroups(1));
    factorName = this.colNames{indGroups(1)};
    
end


% levels are unique group values
groups = unique(valuesGroup(:));

% create group names if this was not specified by table
if isempty(groupNames)
    groupNames = cellstr(num2str(groups));
end

nGroups = length(groups);


% number of synthetic descriptive stats
nStats = 3;
statNames = {'mean', 'std', 'sem'};

% allocate memory for result
resValues = zeros(nGroups, nStats);

% Compute stats for each group
for i = 1:nGroups
    % extract the values of the current group
    vals = values(valuesGroup == groups(i));
  
    resValues(i, 1) = mean(vals);
    resValues(i, 2) = std(vals);
    resValues(i, 3) = resValues(i,2) / sqrt(length(vals));
end

% create result data table
res = Table.create(resValues, ...
    'rowNames', groupNames, ...
    'colNames', statNames, ...
    'name', [name '.' factorName]);
