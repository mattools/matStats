function varargout = boxplot(varargin)
%BOXPLT Box plot of a data table
%
%   output = boxplot(input)
%
%   Example
%   boxplot
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract calling object
indThis = cellfun('isclass', varargin, 'Table');
this = varargin{indThis(1)};
varargin(indThis(1)) = [];

% determines whether an axis handle is given as argument
ax = gca;
if ~isempty(varargin)
    if ishandle(varargin{1})
        ax = varargin{1};
        varargin(1) = [];
    end
end

% default: box plot of each column
data = this.data;
indCols = 1:length(this.colNames);

% determines if columns are specified
if ~isempty(varargin)
    if sum(isColumnName(this, varargin{1})) > 0
        indCols = columnIndex(this, varargin{1});
        data = this.data(:, indCols);
        varargin(1) = [];
    end
end

% check grouping
grouping = false;
indGroup = [];
if ~isempty(varargin)
    if sum(isColumnName(this, varargin{1})) > 0
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
        groupOrder = group(I);
    end
end


% performs boxplot using Statistics toolbox
if ~grouping
    % Box plot of (selected) columns, without grouping
    h = boxplot(ax, data, ...
        'labels', this.colNames(indCols), ...
        varargin{:});
    
else
    % Box plot of (selected) columns, grouped by factor(s)
    h = boxplot(ax, data, group, ...
        'groupOrder', groupOrder, ...
        'labels', this.colNames(indCols), ...
        varargin{:});
    
    % labels
    xlabel(this.colNames(indGroup(1)));
    ylabel(this.colNames(indCols(1)));

end

% decorate box plot
if ~isempty(this.name)
    title(this.name, 'interpreter', 'none');
end


if nargout > 0
    varargout = {h};
end
