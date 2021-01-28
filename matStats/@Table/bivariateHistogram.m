function [histo, xEdges, yEdges]  = bivariateHistogram(varargin)
% Bivariate histogram of features within a table.
%
%   COUNTS = bivariateHistogram(TAB1, TAB2);
%   Computes the bivariate histogram of the two features in TAB1 and TAB2,
%   each one being a 1-column Table object.
%   The result HIST is a 2D numeric array.
%
%   COUNTS = bivariateHistogram(TAB1, TAB2, NBINS);
%   Specifies the number of bins for each column, as a 1-by-2 row vector.
%
%
%   bivariateHistogram(...);
%   Displays the result in a new figure.
%
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     figure; 
%     bivariateHistogram(iris(:,1), iris(:,2), [20 20])
%
%   See also
%     histogram, scatterPlot, hist3, histcounts2
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-01-28,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.


%% Parse input arguments

% check if first argument is an axis handle
arg = varargin{1};
if isscalar(arg) && ishandle(arg) && strcmp(get(arg, 'type'), 'axes')
    ax = arg;
    varargin(1) = [];
else
    ax = [];
end

% Default syntax is to provide two input tables
if length(varargin) < 2
    error('Requires at least two input arguments');
end

obj = varargin{1};

var2 = varargin{2};
if isa(var2, 'Table')
    tab1 = obj; tab2 = var2;
    data = [obj.Data(:,1) var2.Data(:,1)];
    varargin(1:2) = [];
end
if size(data, 2) ~= 2
    error('Input data must be tables with only one column');
end

% check if next argument is number of bins
nBins = [];
if ~isempty(varargin) && isnumeric(varargin{1})
    nBins = varargin{1};
    varargin(1) = [];
end

% the remaining arguments are assumed to be plot options
plotArgs = varargin;


%% Initializations

if isempty(nBins)
     % use a 10-by-10 grid as default grid
    nBins = [10 10];
end


%% Process

% well, simply relies on the histcounts2 function...
[counts, xEdges, yEdges] = histcounts2(data(:,1), data(:,2), nBins);

if 0 < nargout
    histo = counts;
    return
end


%% Display

% space between bars, relative to bar size
del = .001; 

% bin widths
binWidths = {xEdges(2)-xEdges(1), yEdges(2)-yEdges(1)};
    
% build x-coords for the eight corners of each bar.
xx = xEdges;
xx = [xx(1:nBins(1))+del*binWidths{1}; xx(2:nBins(1)+1)-del*binWidths{1}];
xx = [reshape(repmat(xx(:)', 2, 1), 4, nBins(1)); NaN(1, nBins(1))];
xx = [repmat(xx(:), 1, 4) NaN(5*nBins(1),1)];
xx = repmat(xx, 1, nBins(2));

% build y-coords for the eight corners of each bar.
yy = yEdges;
yy = [yy(1:nBins(2))+del*binWidths{2}; yy(2:nBins(2)+1)-del*binWidths{2}];
yy = [reshape(repmat(yy(:)', 2, 1), 4, nBins(2)); NaN(1, nBins(2))];
yy = [repmat(yy(:), 1, 4) NaN(5*nBins(2), 1)];
yy = repmat(yy', nBins(1), 1);

% build z-coords for the eight corners of each bar.
zz = zeros(5*nBins(1), 5*nBins(2));
zz(5*(1:nBins(1))-3, 5*(1:nBins(2))-3) = counts;
zz(5*(1:nBins(1))-3, 5*(1:nBins(2))-2) = counts;
zz(5*(1:nBins(1))-2, 5*(1:nBins(2))-3) = counts;
zz(5*(1:nBins(1))-2, 5*(1:nBins(2))-2) = counts;


% Plot the bars in a light steel blue.
colors = repmat(cat(3,.75,.85,.95), [size(zz) 1]);

% Plot the surface, using any specified graphics properties to override
% defaults.
ax = newplot(ax);
surf(ax, xx, yy, zz, colors, 'Tag', 'bivariateHistogram', plotArgs{:});


if ~ishold(ax)
    % Set ticks for each bar if fewer than 16 and the centers/edges are
    % integers. Otherwise, leave the default ticks alone.
    if (nBins(1) < 16)
        xCenters = (xEdges(1:end-1) + xEdges(2:end)) / 2;
        if all(floor(xCenters) == xCenters)
            set(ax, 'xtick', xCenters);
        end
    end
    if (nBins(2) < 16)
        yCenters = (yEdges(1:end-1) + yEdges(2:end)) / 2;
        if all(floor(yCenters) == yCenters)
            set(ax, 'ytick', yCenters);
        end
    end
    
    % Set the axis limits to have some space at the edges of the bars.
    dx = range(xEdges) * 0.05;
    dy = range(yEdges) * 0.05;
    set(ax, 'xlim', [xEdges(1)-dx xEdges(end)+dx]);
    set(ax, 'ylim', [yEdges(1)-dy yEdges(end)+dy]);
    
    % annotate plot with column names of parent tables
    xlabel(ax, tab1.ColNames{1}, 'Interpreter', 'None');
    ylabel(ax, tab2.ColNames{1}, 'Interpreter', 'None');
    zlabel(ax, 'Count');
    
    % arrange view
    view(ax, 3);
    grid(ax, 'on');
    set(get(ax, 'parent'), 'renderer', 'zbuffer');
end

if nargout > 0
    histo = counts;
end

end
