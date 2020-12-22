function pairPlot(obj, varargin)
% Pairwise scatter plots and histograms of table columns.
%
%   pairPlot(TAB)
%   Pair-wise plot of the columns in the specified table.
%
%   pairPlot(TAB, GRP)
%   Pair-wise plot of the columns in the specified table, using a
%   coloration by group.
%
%   pairPlot(..., PNAME, PVALUE)
%   Specifies additional parameter name-vale pairs. Parameters can be:
%   * 'Colors':     the color associated to each group, as a NG-by-3 array
%   * 'HistMode':   the display mode of the histogram on the diagonal. Can
%                   be one of {'Histogram', 'Bar', 'kde'}.
%
%   Examples
%     % Display pair-wise plot of a simple table
%     iris = Table.read('fisherIris');
%     figure;
%     pairPlot(iris(:,1:4));
%     % Same display using different color per group
%     figure;
%     colors = parula(3);
%     pairPlot(iris(:,1:4), iris(:,5), 'Colors', colors);
%
%   See also
%     correlationCircles, plot, histogram, violinPlot, scatterPlot
%
%   References:
%   Rewritten from the function 'pairplot', by Ryosuke Takeuchi on the
%   FileExchange
%   https://fr.mathworks.com/matlabcentral/fileexchange/60866-pairplot-meas-label-group-colors-mode
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-21,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


%% Parse input arguments

% Check if group argument is provided
groups = {};
if nargin > 1 
    var1 = varargin{1};
    if isa(var1, 'Table')
        [groups, groupNames] = parseGroupInfos(var1);
        groups = groupNames(groups);
        nGroups = length(groupNames);
        varargin(1) = [];

    elseif iscell(varargin{1})
        groups = var1;
        groupNames = unique(groups);
        nGroups = length(groupNames);
        varargin(1) = [];
    end
end

% parse group colors
colors = lines(length(unique(groups)));
if ~isempty(varargin) &&  isnumeric(varargin{1})
    colors = varargin{1};
    varargin(1) = [];
end

% parse optional arguments
[colors, varargin] = parseInputOption(varargin, 'Colors', colors);
[histMode, varargin] = parseInputOption(varargin, 'HistMode', 'histogram'); %#ok<ASGLU>


%% Pre processing

% retrieve data and feature names
data = obj.Data;
nc = size(data, 2);
labels = obj.ColNames;


%% Scatter plots
for i = 1:nc
	for j = 1:nc
        % select appropriate axis
		ax = subplot(nc, nc, sub2ind([nc nc], i, j));
        
        if i == 1
            ylabel(labels{j});
        end
        if j == nc
            xlabel(labels{i});
        end
        
		hold on;
        
        if i == j
            continue;
        end
        
        if isempty(groups)
            plot(ax, data(:, i), data(:, j), '.');
        else
            for g = 1:nGroups
                inds = strcmp(groups, groupNames{g});
                plot(ax, data(inds, i), data(inds, j), ...
                    '.', 'Color', colors(g,:));
            end
        end
        xlim([min(data(:, i)) max(data(:, i))])
	end
end

%% Plot histograms
for i = 1:nc
    % select appropriate axis
    ax = subplot(nc, nc, sub2ind([nc nc], i, i));
    hold on;
    
    bins = linspace(min(data(:,i)), max(data(:,i)), 20);
        
    if strcmpi(histMode, 'histogram')
        % Display histograms
        if isempty(groups)
            histogram(ax, data(:, i), bins, 'Normalization', 'probability');
        else
            for g = 1:nGroups
                inds = strcmp(groups, groupNames{g});
                histogram(ax, data(inds, i), bins, 'FaceColor', colors(g,:), ...
                    'Normalization', 'probability');
            end
        end
        xlim([bins(1) bins(end)]);

    elseif strcmpi(histMode, 'bar')
        % Display bars

        % convert bin centers to edges
        db = diff(bins) / 2;
        edges = [bins(1)-db(1), bins(1:end-1)+db, bins(end)+db(end)];
        edges(2:end) = edges(2:end) + eps(edges(2:end));
        
        if isempty(groups)
            [counts, ~] = histcounts(data(:, i), edges);
            bar(ax, bins, counts, 'BarWidth', 1, 'FaceColor', colors(g,:))
        else
            for g = 1:nGroups
                inds = strcmp(groups, groupNames{g});
                [counts, ~] = histcounts(data(inds, i), edges);
                bar(ax, bins, counts, 'BarWidth', 1, 'FaceColor', colors(g,:))
            end
        end
        xlim([edges(1) edges(end)]);

    elseif strcmpi(histMode, 'kde')
        % Use kernel-density estimate
        if isempty(groups)
            [f, xf] = ksdensity(data(:,i));
            plot(ax, xf, f);
        else
            for g = 1:nGroups
                inds = strcmp(groups, groupNames{g});
                [f, xf] = ksdensity(data(inds,i));
                plot(ax, xf, f, 'Color', colors(g,:));
            end
        end
        
    elseif strcmpi(histMode, 'cdf')
        % Display cumulative density functions
        if isempty(groups)
            [f, x] = ecdf(data(inds, i));
            plot(ax, x, f);
        else
            for g = 1:nGroups
                inds = strcmp(groups, groupNames{g});
                [f, x] = ecdf(data(inds, i));
                plot(ax, x, f, 'Color', colors(g,:));
            end
        end
    end
end

