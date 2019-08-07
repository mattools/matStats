function varargout = scatterGroup3d(this, varargin)
%SCATTERGROUP3D Scatter plot individuals grouped by classes
%
%   scatterGroup3d(VAR1, VAR2, VAR3, GROUP)
%
%   VAR1 is either the index or the name of the column used for x-coord
%   VAR2 is either the index or the name of the column used for y-coord
%   GROUP is a vector with the same number of elements as the number of
%   rows in the table, with P different values
%
%   scatterGroup3d(TAB, IND1, IND2, IND3, VARCLASS)
%   VARCLASSES is either the index or the name of the column in the data
%   table which will be used for identifying classes
%
%   scatterGroup3d(..., 'envelope', TYPE)
%   Display an envelope around the data points of each group. TYPE is a
%   string that can be one of the following:
%   * 'none':           nothing is displayed  (default) 
%   * 'convexhull':     the convex hull of the points is displayed
%   * 'ellipsoid':      the inertia ellipse of each group
%   Display of ellipsoids requires the MatGeom Toolbox.
%
%   scatterGroup3d(..., 'groupColors', COLORS)
%   scatterGroup3d(..., 'groupMarkers', MARKERS)
%   Specifies the type and the color of the markers. COLORS is a NG-by-3
%   array of double, MARKERS is a NG-by-1 cell array of strings.
%
%   scatterGroup3d(..., 'keepGroupName', BOOL)
%   Specifies if the name of the group should appear in the legend.
%
%
%   See also
%     scatter, scatterNames
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-08,    using Matlab 7.4.0.287 (R2007a)
% Copyright 2012 INRA Cepia Software Platform
 
%   HISTORY


%% Extract main data

if size(this.Data, 2) == 1
    % Data are given as separate arrays
    
    if nargin < 4 || ~isa(varargin{1}, 'Table')
        error(['Table:' mfilename ':NotEnoughArguments'], ...
            'Second argument must be another table');
    end
    
    xdata = this.Data(:, 1);
    nameX = this.ColNames{1};
    
    var1 = varargin{1};
    ydata = var1.Data(:, 1);
    nameY = var1.ColNames{1};
    
    var2 = varargin{2};
    zdata = var2.Data(:, 1);
    nameZ = var2.ColNames{1};
    
    group = varargin{3};
    varargin(1:3) = [];

% else
%     % Data are given as one table and three column names/indices
%     if nargin < 3 
%         error(['Table:' mfilename ':NotEnoughArguments'], ...
%             'Need to specify names of x, y and group columns');
%     end
%     
%     % index of first column
%     var1 = varargin{1};
%     indx = this.columnIndex(var1);
%     xdata = this.data(:, indx(1));
%     nameX = this.colNames{indx(1)};
% 
%     % index of second column
%     var2 = varargin{2};
%     indy = this.columnIndex(var2);
%     ydata = this.data(:, indy(1));
%     nameY = this.colNames{indy(1)};
%     
%     var3 = varargin{3};
%     if isa(var3, 'Table')
%         group = var3.data;
%     else
%         % index of third column
%         indG = this.columnIndex(var3);
%         group = this.data(:, indG(1));
%     end    
%     varargin(1:3) = [];
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
envelope = 'none';
% ind = find(strcmp(varargin, 'envelope'));
% if ~isempty(ind)
%     envelope = varargin{ind+1};
%     varargin(ind:ind+1) = [];
% end

% should we keep the name of the group in the legend ?
keepGroupName = ~isempty(this.colNames{1});
% ind = find(strcmp(varargin, 'keepGroupName'));
% if ~isempty(ind)
%     keepGroupName = varargin{ind+1};
%     varargin(ind:ind+1) = [];
% end

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
    
    hm(i) = plot3(xdata(inds), ydata(inds), zdata(inds), ...
        'lineStyle', 'none', ...
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
            
        case 'ellipsoid'
            center  = mean([xdata(inds) ydata(inds) zdata(inds)]);
            sigma   = std([xdata(inds) ydata(inds) zdata(inds)]) * 1.96; 
            hl(i)   = drawEllipsoid([center sigma 0 0 0],...
                'marker', 'none', 'linestyle', 'none', 'FaceAlpha', .5, ...
                'FaceColor', groupColors(i,:), varargin{:});
            
        case 'inertiaellipsoid'
            elli    = inertiaEllipsoid([xdata(inds) ydata(inds) zdata(inds)]);
            hl(i)   = drawEllipsoid(elli,...
                'marker', 'none', 'FaceAlpha', .5, ...
                'drawEllipses', true, 'EllipseColor', 'k', 'ellipseWidth', 1, ...
                'FaceColor', groupColors(i,:), varargin{:});
            
        otherwise
            error(['Can not understand envelope type: ' envelope]);
    end
end


%% graph decorations

% add plot annotations
xlabel(nameX);
ylabel(nameY);
zlabel(nameZ);
if ~isempty(this.name)
    title(this.name, 'Interpreter', 'none');
end

% add some perspective
view(3);

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

