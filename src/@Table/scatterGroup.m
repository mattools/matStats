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
%   % scatterGroup(TAB1, VAR1, VAR2, TAB2, VARCLASS)
%   % Considers that the classes are stored in a separate table.
%   % (not yet implemented)
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
            'Need to specify names of x and y columns');
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
    else
        % index of third column
        indG = this.columnIndex(var3);
        group = this.data(indG(1));
    end    
    varargin(1:3) = [];
end

% extraction of groups indices and labels from input table
[groupIndices groupLabels, groupNames] = parseGroupInfos(group);
groupLabels = formatLevelLabels(groupLabels, groupNames); 

% number of groups
nGroups = length(groupLabels);

% kind of decoration for the graph
envelope = 'convexhull';
ind = find(strcmp(varargin, 'envelope'));
if ~isempty(ind)
    envelope = varargin{ind+1};
    varargin(ind:ind+1) = [];
end


% default graphical for classes
if length(varargin) < nGroups
    styles = generateMarkerStyles(nGroups);
end

% open figure
gcf; hold on;

% plot each class
hm = zeros(nGroups, 1);
hl = zeros(nGroups, 1);

for i = 1:nGroups
    inds = find(groupIndices == i);
    hm(i) = plot(xdata(inds), ydata(inds), styles{i}{:});
    
    switch lower(envelope)
        case 'none'
            % do nothing more...
            
        case 'convexhull'
            inds2   = convhull(xdata(inds), ydata(inds));
            hl(i) = plot(xdata(inds(inds2)), ydata(inds(inds2)), ...
                styles{i}{:}, 'marker', 'none', 'linestyle', '-', 'lineWidth', 2);
            
        case 'ellipse'
            center  = mean([xdata(inds) ydata(inds)]);
            sigma   = std([xdata(inds) ydata(inds)]) * 1.96; 
            hl(i)   = drawEllipse([center sigma 0],...
                styles{i}{:}, 'marker', 'none', 'linestyle', '-', 'lineWidth', 2);
            
        case 'inertiaellipse'
            elli  = inertiaEllipse([xdata(inds) ydata(inds)]);
            hl(i)   = drawEllipse(elli,...
                styles{i}{:}, 'marker', 'none', 'linestyle', '-', 'lineWidth', 2);
            
        otherwise
            error(['Can not understand parameter value: ' envelope]);
    end
end


%% graph decorations

% add plot annotations
xlabel(nameX);
ylabel(nameY);
if ~isempty(this.name)
    title(this.name, 'Interpreter', 'none');
end
legend(hm, groupLabels{:});

% eventually returns handle to graphics
if nargout == 1
    varargout = {hm};
elseif nargout == 2
    varargout = {hm, hl};
end

