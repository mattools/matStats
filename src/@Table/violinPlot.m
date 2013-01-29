function violinPlot(varargin)
%VIOLINPLOT Plot distribution of data in a table
%
%   violinPlot(TAB)
%   Display the violin plot of each column in tabel TAB.
%
%
%   Example
%     % Show distribution of the variables in iris table
%     iris = Table.read('fisherIris');
%     violinPlot(iris(:,1:4));
%
%     % Display distribution of petal width for each group
%     figure; set(gca, 'fontsize', 14);
%     violinPlot(iris('PetalWidth'), iris('Species'), 'y');
%
%   See also
%     boxplot
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-01-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


% Extract the axis handle to draw in
[ax varargin] = parseAxisHandle(varargin{:});

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
        [groupIndices levels groupLabel] = parseGroupInfos(var1);
        
        varargin(1) = [];
        
    elseif sum(isColumnName(this, var1)) > 0
        indGroup = columnIndex(this, varargin{1});
        groupIndices = this.data(:, indGroup);
        grouping = true;
        varargin(1) = [];
        
        if ~isempty(this.levels{indGroup})
            levels = this.levels{indGroup};
        else
            levels = strtrim(cellstr(num2str(unique(groupIndices(:)))));
        end

        groupLabel = this.colNames(indGroup(1));

    end
end

axes(ax); %#ok<MAXES>
hold on;

if isempty(varargin)
    varargin = {'c'};
end

if grouping
    nGroups = max(groupIndices);
    for i = 1:nGroups
        inds = groupIndices == i;
        [f xf] = ksdensity(data(inds,1));
        f = f * .5 / max(f);
        
        fill([i+f i-f(end:-1:1)], [xf xf(end:-1:1)], varargin{:});
        plot(i+f, xf);
        plot(i-f, xf);

    end
    
    xlim([0 nGroups+1]);
    set(gca, 'xtick', 1:nGroups);
    set(gca, 'xticklabel', levels);
    
    xlabel(groupLabel);
    ylabel(this.colNames(indCols(1)), 'interpreter', 'none');

else
    % Display violin plot of each column in table    

    nCols = size(this, 2);
    
    for i = 1:nCols
        [f xf] = ksdensity(this.data(:, i));
        f = f * .5 / max(f);
        
        fill([i+f i-f(end:-1:1)], [xf xf(end:-1:1)], varargin{:});
        plot(i+f, xf);
        plot(i-f, xf);
    end
    
    xlim([0 nCols+1]);
    
    set(gca, 'xtick', 1:nCols);
    set(gca, 'xticklabel', this.colNames);
    
end

% decorate box plot
if ~isempty(this.name)
    title(this.name, 'interpreter', 'none');
end

% if nargout > 0
%     varargout = {h};
% end
