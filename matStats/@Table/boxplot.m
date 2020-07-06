function varargout = boxplot(varargin)
% Box plot of a data table.
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
%     violinPlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

% extract calling object
indThis = cellfun(@(x) isa(x, 'Table'), varargin);
obj = varargin{indThis(1)};
varargin(indThis(1)) = [];

% default: box plot of each column
data = obj.Data;
indCols = 1:length(obj.ColNames);


% check grouping
grouping = false;
if ~isempty(varargin)
    var1 = varargin{1};
    
    if isa(var1, 'Table') || (iscell(var1) && length(var1) == size(obj, 1))
        grouping = true;
        [group, levels, groupLabel] = parseGroupInfos(var1);
%         group = levels(group);
        
        varargin(1) = [];
        
    elseif sum(isColumnName(obj, var1)) > 0
        indGroup = columnIndex(obj, varargin{1});
        group = obj.Data(:, indGroup);
        grouping = true;
        varargin(1) = [];
        
        if isFactor(obj, indGroup)
            levels = obj.Levels{indGroup};
        else
            levels = strtrim(cellstr(num2str(unique(group(:)))));
        end
        
%         [B I J] = unique(group); %#ok<ASGLU>
%         group = levels(J);
        groupLabel = obj.ColNames(indGroup(1));

    end
end


% performs boxplot (using Statistics toolbox)
if ~grouping
    % Box plot of (selected) columns, without grouping
    h = boxplot(ax, data, ...
        'labels', obj.ColNames(indCols), ...
        varargin{:});
    
else
    % Box plot of (selected) columns, grouped by factor(s)
    h = boxplot(ax, data, group, ...
        'labels', levels, ...
        varargin{:});
    
    % labels
    xlabel(groupLabel, 'interpreter', 'none');
    ylabel(obj.ColNames(indCols(1)), 'interpreter', 'none');

end

% decorate box plot
if ~isempty(obj.Name)
    title(obj.Name, 'interpreter', 'none');
end


if nargout > 0
    varargout = {h};
end
