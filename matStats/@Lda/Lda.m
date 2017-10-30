classdef Lda < handle
%LDA  Performs a Fisher's Linear Discriminant Analysis
%
%   RES = Lda(TAB, GROUP);
%   Performs Linear Discriminant Analysis (LDA) of the data table TAB
%   with N rows and P columns, with Q groups specified in the table GROUP.
%   Returns the result in a new instance of Lda class with the following
%   fields: 
%     scores        the new coordinates of individuals, as N-by-P array
%     loadings      the loadinds (or coefficients) of Lda, as P-by-P array
%     eigenValues   values of inertia, inertia percent and cumulated inertia
%     means         the mean value of each column of original data array
%   
%   res = Lda(TAB, GROUP, PARAM, VALUE);
%   Specified some processing options using parameter name-value pairs.
%   Available options are: 
%
%   'display'   {'on'} or 'off',  specifies if figures should be displayed
%               or not. 
%
%   'obsNames' character array with value 'on' or 'off', indicating whether
%       row names should be displayed on score plots, or if only dots are
%       plotted. 
%       Default value is 'on' if number of observations is less than 200.
%
%   'varNames' character array with value 'on' (the default) or 'off',
%       indicating whether column names should be displayed on loadings
%       plots, or if only dots are plotted.
%       Default value is 'on' if number of variables is less than 50.
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
%   'axesProperties' a cell array of parameter name-value pairs, that will
%       be applied to each newly created figure.
%
%   Example
%     % Principal component Analysis of Fisher's iris
%     iris = Table.read('fisherIris');
%     iris_lda = Lda(iris(:,1:4), iris('Species'));
%
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % The name of the input table
    tableName;
    
    % group associated to each observation
    group;

    % the mean value of each variable
    % (used for projecting new observations)
    means;
    
    % the total sum of squared differences (P-by-P)
    ssd_t;
    
    % the sum of squared differences between groups (P-by-P)
    ssd_b;
    
    % the sum of squared differences within groups (P-by-P)
    ssd_w;

    % Table of coordinates of each individual in new coordinate system
    % N-by-(Q-1) (Q: Number of classes/groups)
    scores;
    
    % Table of coordinates of each variable in the new coordinate system
    % P-by-(Q-1)
    loadings;
    
    % The array of eigen values, inertia, and cumulated inertia
    % NC-by-3 
    eigenValues;

    stats;
end % end properties


%% Constructor
methods
    function this = Lda(data, group, varargin)
        % Constructor for Lda class

        % avoid empty constructor
        if nargin == 0
            error('Lda requires at least one input argument');
        end
        
        % copy constructor
        if isa(data, 'Lda')
            % copy the name
            this.tableName      = data.tableName;
            
            % deep copy of related tables
            this.scores         = Table(data.group);
            this.scores         = Table(data.scores);
            this.loadings       = Table(data.loadings);
            this.eigenValues    = Table(data.eigenValues);
            return;
        end
        
        
        %% Initialize raw data
        
        % ensure data is a data table
        if isnumeric(data)
            data = Table(data);
        end
        if isnumeric(group)
            group = Table(group);
        end
        
        % ensure data table has a valid name
        if isempty(data.name)
            data.name = inputname(1);
        end
        
        
        %% Parse input arguments
        
        if mod(length(varargin), 2) > 0
            error('Should specify options as parameter name-value pairs');
        end
        
        nObs  = size(data, 1);
        nVars = size(data, 2);
        
        % other options
        display         = true;
        showObsNames    = nObs  < 200;
        showVarNames    = nVars < 50;
        saveFiguresFlag = false;
        dirFigures      = pwd;
        saveResultsFlag = false;
        dirResults      = pwd;
        axesProperties  = {};

        while length(varargin) > 1
            paramName = varargin{1};
            switch lower(paramName)
                case 'display'
                    display = parseBoolean(varargin{2});
                case 'saveresults'
                    saveResultsFlag = parseBoolean(varargin{2});
                case 'resultsdir'
                    dirResults = varargin{2};
                case 'savefigures'
                    saveFiguresFlag = parseBoolean(varargin{2});
                case 'figuresdir'
                    dirFigures = varargin{2};
                case 'showobsnames'
                    showObsNames = parseBoolean(varargin{2});
                case 'showvarnames'
                    showVarNames = parseBoolean(varargin{2});
                case 'axesproperties'
                    axesProperties = varargin{2};
                otherwise
                    error(['Unknown parameter name: ' paramName]);
            end
            
            varargin(1:2) = [];
        end
        
        % store model information
        this.tableName      = data.name;
        this.group          = group;

        % compute Lda results
        computeLDA(this, data);
        
        % save results
        if saveResultsFlag
            saveResults(this, dirResults);
        end
        
        % display results
        if display
            handles = displayResults(this, showObsNames, showVarNames, axesProperties);
            if saveFiguresFlag
                saveFigures(this, handles, dirFigures);
            end
        end
        
        function b = parseBoolean(string)
            if islogical(string)
                b = string;
            elseif ischar(string)
                b = sum(strcmpi(string, {'true', 'on'})) > 0;
            elseif isnumeric(string)
                b = string ~= 0;
            end
        end
        
    end % end of main constructor

end % end constructors

%% Computation Methods
methods (Access = private)
    function computeLDA(this, tab)
        % Compute the variance matrices, and the transformed data

        % size of data table
        data = tab.data;
        nInds = size(data, 1);
        nVars = size(data, 2);
        
        % number of group / classes
        [uniGroups, tmp, groupIndices] = unique(this.group.data); %#ok<ASGLU>
        nGroups = length(uniGroups);
        
        % recenter data
        this.means = mean(data);
        data = bsxfun(@minus, data, this.means);
        
        % find the maximal dimension
        nDims = min(nGroups-1, nVars);
        
        %% Compute the matrices of the problem
        
        % sum of squared differences (total)
        this.ssd_t = data' * data;
        
        % initialize arrays for computing group means
        groupCounts = zeros(nGroups, 1);
        groupMeans = zeros(nGroups, nVars);
        
        % initialize the "between groups" sum of squared differences
        this.ssd_b = zeros(nVars, nVars);
        
        % initialize the "within groups" sum of squared differences
        this.ssd_w = zeros(nVars, nVars);
        
        % Compute matrices by iterating over groups
        for i = 1:nGroups
            inds = groupIndices == i;
            groupCounts(i) = sum(inds);
            
            % compute groupe mean
            mu_i = mean(data(inds, :));
            groupMeans(i,:) = mu_i;
            this.ssd_b = this.ssd_b + (mu_i' * mu_i) * groupCounts(i);
            
            % group data centered on group mean
            gdata = bsxfun(@minus, data(inds,:), mu_i);
            
            % update residual sum of square differences (within groups)
            this.ssd_w = this.ssd_w + gdata' * gdata;
        end

        
        %% Extraction of eigen vectors
        
        % Compute first eigen vectors
        % (function "manova1" uses a more complicated algorithm, 
        [v, ev] = eigs(this.ssd_b, this.ssd_w, nDims, 'largestabs');
        ev = diag(ev);

        % Re-scale eigenvectors to ensure the within-group variance is 1
        vs = diag(v' * this.ssd_w * v)' ./ (nInds - nGroups);
        vs(vs<=0) = 1;
        v = v ./ repmat(sqrt(vs), size(v,1), 1);

        
        %% Create Result Tables
        
        % name of new columns
        varNames = strtrim(cellstr(num2str((1:nDims)', 'cc%d')));
        
        % Table object for canonical coordinates
        if ~isempty(tab.name)
            name = sprintf('Can. Coords of %s', tab.name);
        else
            name = 'Can. Coords';
        end
        this.scores = Table.create(data * v(:,1:nDims), ...
            'rowNames', tab.rowNames, ...
            'colNames', varNames, ...
            'name', name);
        
        % Table object for eigen vectors
        if ~isempty(tab.name)
            name = sprintf('Loadings of %s', tab.name);
        else
            name = 'Loadings';
        end
        this.loadings = Table.create(v(:,1:nDims), ...
            'rowNames', tab.colNames, ...
            'colNames', varNames, ...
            'name', name);
        
        % compute array of eigen values
        eigenVals = zeros(length(ev), 3);
        eigenVals(:, 1) = ev;                       % eigen values
        eigenVals(:, 2) = 100 * ev / sum(ev);       % inertia
        eigenVals(:, 3) = cumsum(eigenVals(:,2));   % cumulated inertia
        
        % Table object for eigen values
        if ~isempty(tab.name)
            name = sprintf('Eigen values of %s', tab.name);
        else
            name = 'Eigen values';
        end
        this.eigenValues = Table.create(eigenVals, ...
            'rowNames', varNames, ...
            'name', name, ...
            'colNames', {'EigenValues', 'Inertia', 'Cumulated'});
    end
end

%% Methods
methods
    
    function saveResults(this, dirResults)
        % Save 3 result files corresponding to Scores, loadings and eigen values
        
        % save score array (coordinates of individuals in new basis)
        fileName = sprintf('%s-cda.scores.txt', this.tableName);
        write(this.scores, fullfile(dirResults, fileName));
        
        % save loadings array (corodinates of variable in new basis)
        fileName = sprintf('%s-cda.loadings.txt', this.tableName);
        write(this.loadings, fullfile(dirResults, fileName));
        
        % save eigen values array
        fileName = sprintf('%s-cda.values.txt', this.tableName);
        write(this.eigenValues, fullfile(dirResults, fileName));
    end

    
    function handles = displayResults(this, showObsNames, showVarNames, ...
            axesProperties)
        % Display results of Lda
        
        % number of canonical components to display
        npc = size(this.scores.data, 2);
        
        % Scree plot of the Lda
        handles.screePlot = screePlot(this, axesProperties{:});
        
        % individuals in plane CC1-CC2
        if npc >= 2
            handles.scorePlot12 = figure;
            scorePlot(this, 1, 2, 'showNames', showObsNames, axesProperties{:});
        end
        
        % individuals in plane CC3-CC4
        if npc >= 4
            handles.scorePlot34 = figure;
            scorePlot(this, 3, 4, 'showNames', showObsNames, axesProperties{:});
        end
        
        
        % loading plots CC1-CC2
        if npc >= 2
            handles.loadingsPlot12 = figure;
            loadingPlot(this, 1, 2, 'showNames', showVarNames, axesProperties{:});
        end
        
        % loading plots CC3-CC4
        if npc >= 4
            handles.loadingsPlot34 = figure;
            loadingPlot(this, 3, 4, 'showNames', showVarNames, axesProperties{:});
        end
    end
    
    function saveFigures(this, handles, dirFigs)
        
        baseName = this.tableName;
        
        fileName = sprintf('%s-lda.ev.png', baseName);
        if ismember(handles, 'screePlot')
            print(handles.screePlot, fullfile(dirFigs, fileName));
        end
        
        if ismember(handles, 'scorePlot12')
            fileName = sprintf('%s-lda.sc12.png', baseName);
            print(handles.scorePlot12, fullfile(dirFigs, fileName));
        end
        
        if ismember(handles, 'scorePlot34')
            fileName = sprintf('%s-lda.sc34.png', baseName);
            print(handles.scorePlot34, fullfile(dirFigs, fileName));
        end

        if ismember(handles, 'loadingsPlot12')
            fileName = sprintf('%s-lda.ld12.png', baseName);
            print(handles.loadingsPlot12, fullfile(dirFigs, fileName));
        end
        
        if ismember(handles, 'loadingsPlot34')
            fileName = sprintf('%s-lda.ld34.png', baseName);
            print(handles.loadingsPlot34, fullfile(dirFigs, fileName));
        end
    end
end % end methods

methods
    function disp(this)
        % Display a short summary about analysis result
        
        disp('Linear Discriminant Analysis Result');
        disp(['   Input data: ' this.tableName]);
        disp(['       scores: ' sprintf('<%dx%d Table>', size(this.scores))]);
        disp(['     loadings: ' sprintf('<%dx%d Table>', size(this.loadings))]);
        disp(['  eigenValues: ' sprintf('<%dx%d Table>', size(this.eigenValues))]);
        disp('Type ''properties(Lda)'' to see all properties');
    end
end

end % end classdef

