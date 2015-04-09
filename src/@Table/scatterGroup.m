function varargout = scatterGroup(this, varargin)
%SCATTERGROUP Scatter plot individuals grouped by classes
%
%   scatterGroup(VAR1, VAR2, GROUP)
%
%   VAR1 is either the index or the name of the column used for x-coord
%   VAR2 is either the index or the name of the column used for y-coord
%   GROUP is a vector with the same number of elements as the number of
%   rows in the table, with P different values
%
%   scatterGroup(TAB, VAR1, VAR2, VARCLASS)
%   VARCLASSES is either the index or the name of the column in the data
%   table which will be used for identifying classes
%
%   scatterGroup(..., 'envelope', TYPE)
%   Display an envelope around the data points of each group. TYPE is a
%   string that can be one of the following:
%   * 'none':           nothing is displayed  (default) 
%   * 'convexhull':     the convex hull of the points is displayed
%   * 'ellipse':        an orthogonal ellipse with same variance in X and Y
%         as the set of points is displayed
%   * 'inertiaellipse': the inertia ellipse of each group
%   Display of ellipses or inertia ellipses requires the MatGeom Toolbox.
%
%   scatterGroup(..., 'groupColors', COLORS)
%   scatterGroup(..., 'groupMarkers', MARKERS)
%   Specifies the type and the color of the markers. COLORS is a NG-by-3
%   array of double, MARKERS is a NG-by-1 cell array of strings.
%
%   scatterGroup(..., 'keepGroupName', BOOL)
%   Specifies if the name of the group should appear in the legend.
%
%   Example
%   % Display some scatter plot of iris classes
%     load fisheriris   % Note: requires Statistics Toolbox
%     names = {'SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'};
%     tab = Table(meas, names);
%     % display points
%     figure; scatterGroup(tab(:,1), tab(:,2), species);
%     % another plot, with ellipses
%     figure; set(gca, 'fontsize', 14);
%     scatterGroup(tab(:,3), tab(:,4), species, 'envelope', 'ellipse')
%
%   % Display some scatter plot of iris classes
%     tab = Table.read('fisherIris.txt');
%     % display points
%     figure; 
%     scatterGroup(tab('PetalLength'), tab('PetalWidth'), tab('Species'));
%     % another plot, with ellipses
%     figure; set(gca, 'fontsize', 14);
%     scatterGroup(tab(:,3), tab(:,4), tab('Species'), 'envelope', 'ellipse')
%
%   See also
%   scatter, scatterNames
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-08,    using Matlab 7.4.0.287 (R2007a)
% Copyright 2007 INRA - BIA PV Nantes - MIAJ Jouy-en-Josas.
 
%   HISTORY


%% Extract main data

if size(this.data, 2) == 1
    % Data are given as separate arrays
    
    if nargin < 3 || ~isa(varargin{1}, 'Table')
        error(['Table:' mfilename ':NotEnoughArguments'], ...
            'Second argument must be another table');
    end
    
    xdata = this.data(:, 1);
    nameX = this.colNames{1};
    
    var1 = varargin{1};
    ydata = var1.data(:, 1);
    nameY = var1.colNames{1};
    
    group = varargin{2};
    varargin(1:2) = [];

else
    % Data are given as one table and three column names/indices
    if nargin < 3 
        error(['Table:' mfilename ':NotEnoughArguments'], ...
            'Need to specify names of x, y and group columns');
    end
    
    % index of first column
    var1 = varargin{1};
    indx = this.columnIndex(var1);
    xdata = this.data(:, indx(1));
    nameX = this.colNames{indx(1)};

    % index of second column
    var2 = varargin{2};
    indy = this.columnIndex(var2);
    ydata = this.data(:, indy(1));
    nameY = this.colNames{indy(1)};
    
    var3 = varargin{3};
    if isa(var3, 'Table')
        group = var3.data;
        levels = var3.levels{1};
    else
        % index of third column
        indG = this.columnIndex(var3);
        group = this.data(:, indG(1));
        levels = this.levels{indG(1)};
    end
    if ~isempty(levels)
        group = levels(group);
    end
    
    varargin(1:3) = [];
end


%% Initialisations

% extraction of groups indices and labels from input table
[groupIndices, groupLabels, groupNames] = parseGroupInfos(group);

% number of groups
nGroups = length(groupLabels);

% default drawing styles
groupColors = generateColors(nGroups);
groupMarkers = generateMarkers(nGroups);
legendLocation = 'NorthEast';
fillMarkers = false(nGroups, 1);


%% Parse input arguments

% kind of decoration for the graph
envelope = 'convexhull';

% should we keep the name of the group in the legend ?
keepGroupName = ~isempty(this.colNames{1});

% parse input options
options = {};
while length(varargin) > 1
    paramName = lower(varargin{1});
    switch paramName
        case 'envelope'
            envelope = varargin{2};
        case 'keepgroupname'
            keepGroupName = varargin{2};
        case 'groupcolors'
            groupColors = varargin{2};
        case 'groupmarkers'
            groupMarkers = varargin{2};
        case 'legendlocation'
            legendLocation = varargin{2};
        case 'fillmarkers'
            fillMarkers = varargin{2};
        otherwise
            % Other parameters are assumed to be general styles
            options = [options varargin(1:2)]; %#ok<AGROW>
    end

    varargin(1:2) = [];
end
varargin = options;


% open figure
gcf; hold on;

% plot each class
hm = zeros(nGroups, 1);
hl = zeros(nGroups, 1);

for i = 1:nGroups
    inds = find(groupIndices == i);

    faceColor = 'none';
    if fillMarkers(i)
        faceColor = groupColors(i,:);
    end
    
    hm(i) = plot(xdata(inds), ydata(inds), 'lineStyle', 'none', ...
        'marker', groupMarkers{i}, 'color', groupColors(i,:), ...
        'MarkerFaceColor', faceColor, varargin{:});
    
    switch lower(envelope)
        case 'none'
            % do nothing more...
            
        case 'convexhull'
            inds2   = convhull(xdata(inds), ydata(inds));
            hl(i)   = plot(xdata(inds(inds2)), ydata(inds(inds2)), ...
                'marker', 'none', 'linestyle', '-', 'lineWidth', 2, ...
                'color', groupColors(i,:), varargin{:});
            
        case 'ellipse'
            center  = mean([xdata(inds) ydata(inds)]);
            sigma   = std([xdata(inds) ydata(inds)]) * 1.96; 
            hl(i)   = drawEllipse([center sigma 0],...
                'marker', 'none', 'linestyle', '-', 'lineWidth', 2, ...
                'color', groupColors(i,:), varargin{:});
            
        case 'inertiaellipse'
            elli    = inertiaEllipse([xdata(inds) ydata(inds)]);
            hl(i)   = drawEllipse(elli,...
                'marker', 'none', 'linestyle', '-', 'lineWidth', 2, ...
                'color', groupColors(i,:), varargin{:});
            
        otherwise
            error(['Can not understand envelope type: ' envelope]);
    end
end


%% graph decorations

% add plot annotations
xlabel(nameX);
ylabel(nameY);
if ~isempty(this.name)
    title(this.name, 'Interpreter', 'none');
end

% Legend of the graph
if keepGroupName
    groupLabels = formatLevelLabels(groupLabels, groupNames); 
end
legend(hm, groupLabels{:}, 'Location', legendLocation);

% eventually returns handle to graphics
if nargout == 1
    varargout = {hm};
elseif nargout == 2
    varargout = {hm, hl};
end


function map = generateColors(n)
% Generate NG different colors. 
% Result is a N-by3 double array, containing color triplets with values
% between 0 and 1.
%

% generate Nc+1 colors. The last one is white, but is not used
if n < 8
    map = [0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
else
    map = colormap(colorcube(n+1));
end


function marks = generateMarkers(n)
% Generate NG different marker types. 
% Result is a cell array of strings.
%

% the basic set of marks
marks = {'+', 'o', '*', 'x', 's', 'd', '^', 'v', '<', '>', 'p', 'h'};
marks = marks(mod((1:n)-1, length(marks)) + 1)';
