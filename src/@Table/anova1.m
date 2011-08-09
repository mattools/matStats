function anova1(this, factor, varargin)
%ANOVA1 One-way analysis of variance
%
%   anova1(DATA, FACTOR)
%   At least DATA or FACTOR should be a data table with one column, the
%   other argument, must be a data table or a column vector the same size.
%   The functions formats inputs, and call the "anova1" function in the
%   statistics toolbox.
%
%   anova1(..., NAME, VALUE)
%   Specifies additional parameters that will be passed to the boxplot
%   function.
%
%   Example
%   anova1
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% extract input data
if isa(this, 'Table')
    data = this.data;
else
    % if data are numeric, assumes factor is Table object
    data = this;
    this = factor;
end

% extract group values
groupNames = {}; 
if isa(factor, 'Table')
    groupValues = factor.data;
    if isFactor(factor, 1)
        groupNames = factor.levels{1};
    end
else
    groupValues = factor;
end

% levels are unique group values
levels = unique(groupValues);

% create group names if this was not specified by table
if isempty(groupNames)
    groupNames = num2str(unique(levels(:)));
end

% number of data and of levels
N   = length(data);
Ng  = length(levels);

% check size of groups
nObsByGroup = N / Ng;
if round(nObsByGroup) ~= nObsByGroup
    errordlg('The number of observations in each group\nmust be the same', ...
        'Bad input size', 'modal');
    return;
end

% create the matrix of groups: one column per group
array = zeros(nObsByGroup, Ng);
for i = 1:Ng
    ind = groupValues == levels(i);
    array(:, i) = data(ind);
end

% performs the anova
[p, resTbl, stats] = anova1(array, groupNames, 'off'); %#ok<ASGLU,NASGU>

% add the name of the factor if needed
if isa(this, 'Table')
    resTbl{2,1} = factor.colNames{1};
end

% display boxplots
boxplot(array, 'labels', groupNames, varargin{:});

% decorate with available info
if isa(factor, 'Table')
    xlabel(factor.colNames{1});
end
if isa(this, 'Table')
    ylabel(this.colNames{1});
end

% display anova results
digits = [-1 -1 0 -1 2 4];
wtitle = 'One-way ANOVA';
ttitle = 'ANOVA Table';
tblfig = statdisptable(resTbl, wtitle, ttitle, '', digits);
set(tblfig, 'tag', 'table');

