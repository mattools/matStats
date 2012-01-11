function varargout = pca(this, varargin)
%PCA Principal components analysis of the data
%
%   Usage
%   SC = pca(TAB);
%   [SC LD] = pca(TAB);
%   [SC LD EV] = pca(TAB);
%   ... = pca(..., PARAM, VALUE);
%
%   Description
%   SC = pca(TAB);
%   Performs Principal components analysis of the data in table and returns
%   the transformed coordinates (scores).
%   
%   [SC LD] = pca(TAB);
%   Also returns loadings.
%
%   [SC LD EV] = pca(TAB);
%   Also returns eigen values, in a 3 column table object. First column
%   corresponds to eigen values, second column contains the inertia, and
%   third columns cotnains cumulative inertia.
%
%   ... = pca(..., PARAM, VALUE);
%   Specified some processing options using parameter name-value pairs.
%   Available options are: 
%
%   'scale'     boolean flag indicating whether the data array should be
%               scaled (the default) or not. If data are scaled, they are
%               divided by their standard deviation.
%
%   'display'   (true) specifies if figures should be displayed or not.
%
%   'showNames' character array with value 'on' (the default) or 'off',
%       indicating whether row names should be displayed on score plots, or
%       if only dots are plotted.
%
%   'saveResults' char array with value 'on' or 'off' indicating whether
%       the results should be saved as text files or not. Default is 'off'.
%
%   'saveFigures' char array with value 'on' or 'off' indicating whether
%       the displayed figures should be saved or not. Default is 'off'.
%
%   'resultsDir' character array indicating the directory to which results
%       will be saved. Default is current directory.
%
%   'figuresDir' character array indicating the directory to which figures
%       will be saved. Default is current directory.
%
%
%   Example
%   pca
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Parse input arguments

% analysis options
scale           = true;

% other options
display         = true;
showNames       = true;
saveFiguresFlag = false;
dirFigures      = pwd;
saveResultsFlag = false;
dirResults      = pwd;

while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'display'
            display = varargin{2};
        case 'scale'
            scale = varargin{2};
        case 'saveresults'
            saveResultsFlag = parseBoolean(varargin{2});
        case 'resultsdir'
            dirResults = varargin{2};
        case 'savefigures'
            saveFiguresFlag = parseBoolean(varargin{2});
        case 'figuresdir'
            dirFigures = varargin{2};
        case 'shownames'
            showNames = parseBoolean(varargin{2});
        otherwise
            error(['Unknown parameter name: ' paramName]);
    end

    varargin(1:2) = [];
end

if ischar(display)
    display = strcmpi(display, 'on');
end


%% Pre-processing

% recenter data (remove mean)
cData = bsxfun(@minus, this.data, mean(this.data, 1));

% optional scaling of data (divide by standard deviation)
if scale
    sigma   = sqrt(var(cData));
    cData   = cData * diag(1 ./ sigma);
end


%% Computation of Principal components

% computation of covariance matrix
V = cData' * cData;  
V = V / (size(cData, 1) - 1);

% Diagonalisation of the covariance matrix.
% * eigenVectors: basis transform matrix
% * vl: eigen values diagonal matrix
% * coord: not used
[eigenVectors, vl, coord] = svd(V); %#ok<NASGU>

% compute new coordinates from the eigen vectors
coord = cData * eigenVectors;

% compute array of eigen values
vl = diag(vl);
eigenValues = zeros(length(vl), 3);
eigenValues(:, 1) = vl;
eigenValues(:, 2) = 100 * vl / sum(vl);
eigenValues(:, 3) = cumsum(eigenValues(:,2));


% computation of correlation circle
if scale
    nv = size(this.data, 2);
    correl = zeros(nv, nv);
    for i = 1:nv
        correl(:,i) = sqrt(vl(i)) * eigenVectors(:,i);
    end
end


%% Create result data tables

% name of new columns
varNames = strtrim(cellstr(num2str((1:size(this.data, 2))', 'pc%d')));

% Table object for new coordinates
if ~isempty(this.name)
    name = sprintf('Scores of %s', this.name);
else
    name = 'Scores';
end
sc = Table.create(coord, ...
    'rowNames', this.rowNames, ...
    'colNames', varNames, ...
    'name', name);

% Table object for loadings
if ~isempty(this.name)
    name = sprintf('Loadings of %s', this.name);
else
    name = 'Loadings';
end
ld = Table.create(eigenVectors, ...
    'rowNames', this.colNames, ...
    'colNames', varNames, ...
    'name', name);

% Table object for eigen values
if ~isempty(this.name)
    name = sprintf('Eigen values of %s', this.name);
else
    name = 'Eigen values';
end
ev = Table.create(eigenValues, ...
    'rowNames', varNames, ...
    'name', name, ...
    'colNames', {'EigenValues', 'Inertia', 'Cumulated'});

% Table object for correlation circle
if scale
    if ~isempty(this.name)
        name = sprintf('Correlations of %s', this.name);
    else
        name = 'Correlations';
    end
    correl = Table.create(correl, ...
        'rowNames', varNames, ...
        'name', name, ...
        'colNames', this.colNames);
end


%% Save and display results if needed

% save results
if saveResultsFlag
    savePcaResults(this.name, sc, ld, ev, dirResults);
end

% display results
if display
    hFigs = displayPcaResults(this.name, sc, ld, ev, showNames);
    
    if saveFiguresFlag
        saveFigures(hFigs, this.name, dirFigures);
    end
end

% display correlation circle
if display && scale
    h = displayCorrelationCircle(name, correl, ev);
    
    if saveFiguresFlag
        fileName = sprintf('%s-pca.cc12.png', name);
        print(h(1), fullfile(dirFigs, fileName));
        
        if ishandle(h(2))
            fileName = sprintf('%s-pca.cc34.png', baseName);
            print(h(2), fullfile(dirFigs, fileName));
        end
    end
end


%% Format output arguments

if nargout == 1
    varargout = {sc};
    
elseif nargout == 3
    varargout = {sc, ld, ev};
end



function savePcaResults(baseName, sc, ld, ev, dirResults)
% Save 3 result files corresponding to Scores, loadings and eigen values

% save score array (coordinates of individuals in new basis)
fileName = sprintf('%s-pca.scores.txt', baseName);
write(sc, fullfile(dirResults, fileName));

% save loadings array (corodinates of variable in new basis)
fileName = sprintf('%s-pca.loadings.txt', baseName);
write(ld, fullfile(dirResults, fileName));

% save eigen values array
fileName = sprintf('%s-pca.values.txt', baseName);
write(ev, fullfile(dirResults, fileName));



%% Display results of PCA
function h = displayPcaResults(name, sc, ld, ev, showNames)

% extract data
coord = sc.data;
eigenValues = ev.data;

% distribution of the first 10 eigen values
h1 = figure('Name', 'PCA - Eigen Values', 'NumberTitle', 'off');
nx = min(10, size(coord, 2));
plot(1:nx, eigenValues(1:nx, 2));
xlim([1 nx]);
xlabel('Number of components');
ylabel('Inertia (%)');
title([name ' - eigen values'], 'interpreter', 'none');

% individuals in plane PC1-PC2
h2 = figure('Name', 'PCA - Comp. 1 and 2', 'NumberTitle', 'off');
x = coord(:, 1);
y = coord(:, 2);
if showNames
    drawText(x, y, sc.rowNames);
else
    plot(x, y, '.k');
end

xlabel(sprintf('Principal component 1 (%5.2f)', eigenValues(1, 2)));
ylabel(sprintf('Principal component 2 (%5.2f)', eigenValues(2, 2)));
title(name, 'interpreter', 'none');

% individuals in plane PC3-PC4
if size(coord, 2) >= 4
    h3 = figure('Name', 'PCA - Comp. 3 and 4', 'NumberTitle', 'off');
    x = coord(:, 3);
    y = coord(:, 4);
    
    if showNames
        drawText(x, y, sc.rowNames);
    else
        plot(x, y, '.k');
    end
    
    xlabel(sprintf('Principal component 3 (%5.2f)', eigenValues(3, 2)));
    ylabel(sprintf('Principal component 4 (%5.2f)', eigenValues(4, 2)));
    title(name, 'interpreter', 'none');
else
    h3 = -1;
end


% loading plots PC1-PC2
h4 = figure('Name', 'PCA Variables - Coords 1 and 2', 'NumberTitle', 'off');

drawText(ld.data(:, 1), ld.data(:,2), ld.rowNames, ...
        'HorizontalAlignment', 'Center');

xlabel(sprintf('Principal component 1 (%5.2f)', eigenValues(1, 2)));
ylabel(sprintf('Principal component 2 (%5.2f)', eigenValues(2, 2)));
title(name, 'interpreter', 'none');


% loading plots PC1-PC2
if size(coord, 2) >= 4
    h5 = figure('Name', 'PCA Variables - Coords 3 and 4', 'NumberTitle', 'off');

    drawText(ld.data(:, 3), ld.data(:,4), ld.rowNames, ...
        'HorizontalAlignment', 'Center');
    
    xlabel(sprintf('Principal component 3 (%5.2f)', eigenValues(3, 2)));
    ylabel(sprintf('Principal component 4 (%5.2f)', eigenValues(4, 2)));
    title(name, 'interpreter', 'none');
end

% return handle array to figures
h = [h1 h2 h3 h4 h5];


function saveFigures(hFigs, baseName, dirFigs)

fileName = sprintf('%s-pca.ev.png', baseName);
print(hFigs(1), fullfile(dirFigs, fileName));

fileName = sprintf('%s-pca.sc12.png', baseName);
print(hFigs(2), fullfile(dirFigs, fileName));

if ishandle(hFigs(3))
    fileName = sprintf('%s-pca.sc34.png', baseName);
    print(hFigs(3), fullfile(dirFigs, fileName));
end

fileName = sprintf('%s-pca.ld12.png', baseName);
print(hFigs(4), fullfile(dirFigs, fileName));

if ishandle(hFigs(5))
    fileName = sprintf('%s-pca.ld34.png', baseName);
    print(hFigs(5), fullfile(dirFigs, fileName));
end


function h = displayCorrelationCircle(name, correl, ev)

eigenValues = ev.data;

% correlation plot PC1-PC2
h1 = figure('Name', 'PCA Correlation Circle - Coords 1 and 2', ...
    'NumberTitle', 'off');

drawText(correl.data(:, 1), correl.data(:,2), correl.colNames, ...
        'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
hold on; plot(correl.data(:, 1), correl.data(:,2), '.');    
makeCircleAxis;

xlabel(sprintf('Principal component 1 (%5.2f)', eigenValues(1, 2)));
ylabel(sprintf('Principal component 2 (%5.2f)', eigenValues(2, 2)));
title(name, 'interpreter', 'none');

% correlation plot PC1-PC2
if size(correl, 2) >= 4
    h2 = figure('Name', 'PCA Correlation Circle - Coords 3 and 4', ...
        'NumberTitle', 'off');
    
    drawText(correl.data(:, 3), correl.data(:,4), correl.colNames, ...
        'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
    hold on; plot(correl.data(:, 3), correl.data(:,4), '.');
    makeCircleAxis;
    
    xlabel(sprintf('Principal component 3 (%5.2f)', eigenValues(3, 2)));
    ylabel(sprintf('Principal component 4 (%5.2f)', eigenValues(4, 2)));
    title(name, 'interpreter', 'none');
    
else
    h2 = -1;
end

h = [h1 h2];


function drawText(x, y, labels, varargin)
%DRAWTEXT display text with specific formating
plot(x, y, '.w');
text(x, y, labels, 'color', 'k', 'fontsize', 8, varargin{:});


function makeCircleAxis
%MAKECIRCLEAXIS Draw a circle and format display
hold on;
x = linspace(0, 2*pi, 200);
plot(cos(x), sin(x), 'k')
axis square;
plot([-1 1], [0 0], ':k');
plot([0 0 ], [-1 1], ':k');
axis([-1.1 1.1 -1.1 1.1]);
hold off;


function b = parseBoolean(input)
% Returns a boolean value from parsing text string

if islogical(input)
    b = input;
    
elseif ischar(input)
    if ismember(lower(input), {'on', 'true'})
        b = true;
    elseif ismember(lower(input), {'off', 'false'})
        b = false;
    else
        error(['Illegal value for logical string argument: ' input]);
    end
elseif isnumeric(input)
    b = input ~= 0;
end
