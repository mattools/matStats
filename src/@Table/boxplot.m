function varargout = boxplot(varargin)
%BOXPLT Box plot of a data table
%
%   boxplot(TAB)
%   Displays boxplots of the columns in data table TAB.
%
%   boxplot(TAB, G)
%   Displays the box plot of the 1-column data table TAB, with groups given
%   by G. G can be either a table obejct with one factor column, a cell
%   array of strings, or a numeric column array.
%
%   boxplot(AX, TAB, ...)
%   Specifies the axis to draw the bowplot in.
%
%   boxplot(..., PARAM, VALUE)
%   additional argument parameter name-value pairs that can be passen to
%   the boxplot function.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     % boxplot of numeric variables
%     boxplot(iris(:,1:4));
%     % Box plot by group
%     figure;
%     boxplot(iris('PetalLength'), iris('Species')));
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% determines whether an axis handle is given as argument
ax = gca;
if ishandle(varargin{1})
    ax = varargin{1};
    varargin(1) = [];
end


% extract calling object
indThis = cellfun('isclass', varargin, 'Table');
this = varargin{indThis(1)};
varargin(indThis(1)) = [];

% default: box plot of each column
data = this.data;
indCols = 1:length(this.colNames);


% check grouping
grouping = false;
if ~isempty(varargin)
    var1 = varargin{1};
    
    if isa(var1, 'Table') || (iscell(var1) && length(var1) == size(this, 1))
        grouping = true;
        [group levels groupLabel] = parseGroupInfos(var1);
        group = levels(group);
        
        varargin(1) = [];
        
    elseif sum(isColumnName(this, var1)) > 0
        indGroup = columnIndex(this, varargin{1});
        group = this.data(:, indGroup);
        grouping = true;
        varargin(1) = [];
        
        if ~isempty(this.levels{indGroup})
            levels = this.levels{indGroup};
        else
            levels = strtrim(cellstr(num2str(unique(group(:)))));
        end
        
        [B I J] = unique(group); %#ok<ASGLU>
        group = levels(J);
        groupLabel = this.colNames(indGroup(1));

    end
end


% performs boxplot (using Statistics toolbox)
if ~grouping
    % Box plot of (selected) columns, without grouping
    h = boxplot(ax, data, ...
        'labels', this.colNames(indCols), ...
        varargin{:});
    
else
    % Box plot of (selected) columns, grouped by factor(s)
    h = boxplot(ax, data, group, ...
        varargin{:});
    
    % labels
    xlabel(groupLabel, 'interpreter', 'none');
    ylabel(this.colNames(indCols(1)), 'interpreter', 'none');

end

% decorate box plot
if ~isempty(this.name)
    title(this.name, 'interpreter', 'none');
end


if nargout > 0
    varargout = {h};
end
