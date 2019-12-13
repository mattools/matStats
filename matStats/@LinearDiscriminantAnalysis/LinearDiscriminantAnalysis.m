classdef LinearDiscriminantAnalysis < handle
%LINEARDISCRIMINANTANALYSIS Performs a Fisher's Linear Discriminant Analysis
%
%   RES = LinearDiscriminantAnalysis(TAB, GROUP);
%   Performs Linear Discriminant Analysis (LDA) of the data table TAB
%   with N rows and P columns, with Q groups specified in the table GROUP.
%   Returns the result in a new instance of LinearDiscriminantAnalysis
%   class with the following fields: 
%     Scores        the new coordinates of individuals, as N-by-P array
%     Loadings      the loadinds (or coefficients) of LinearDiscriminantAnalysis, as P-by-P array
%     EigenValues   values of inertia, inertia percent and cumulated inertia
%     Means         the mean value of each column of original data array
%   
%   res = LinearDiscriminantAnalysis(TAB, GROUP, PARAM, VALUE);
%   Specifies some processing options using parameter name-value pairs.
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
%     iris_lda = LinearDiscriminantAnalysis(iris(:,1:4), iris('Species'));
%
%   See also
%     manova1 (statistics toolbox), Pca
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % The name of the input table
    TableName;
    
    % group associated to each observation
    Group;

    % the mean value of each variable
    % (used for projecting new observations)
    Means;
    
    % the total sum of squared differences (P-by-P)
    SSD_T;
    
    % the sum of squared differences between groups (P-by-P)
    SSD_B;
    
    % the sum of squared differences within groups (P-by-P)
    SSD_W;

    % Table of coordinates of each individual in new coordinate system
    % N-by-(Q-1) (Q: Number of classes/groups)
    Scores;
    
    % Table of coordinates of each variable in the new coordinate system
    % P-by-(Q-1)
    Loadings;
    
    % The array of eigen values, inertia, and cumulated inertia
    % NC-by-3 
    EigenValues;

    Stats;
    
end % end properties


%% Constructor
methods
    function obj = LinearDiscriminantAnalysis(data, group, varargin)
        % Constructor for LinearDiscriminantAnalysis class

        % avoid empty constructor
        if nargin == 0
            error('LinearDiscriminantAnalysis requires at least one input argument');
        end
        
        % copy constructor
        if isa(data, 'LinearDiscriminantAnalysis')
            % copy the name
            obj.TableName      = data.TableName;
            
            % deep copy of related tables
            obj.Group          = Table(data.Group);
            obj.Scores         = Table(data.Scores);
            obj.Loadings       = Table(data.Loadings);
            obj.EigenValues    = Table(data.EigenValues);
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
        
        % Parse input arguments
        options = createDefaultOptions(data);
        options = parseInputArguments(options, varargin{:});
        
        % store model information
        tableName = data.Name;
        if isempty(tableName)
            tableName = inputname(1);
        end
        obj.TableName      = tableName;
        obj.Group          = group;

        % compute LinearDiscriminantAnalysis results
        computeLDA(obj, data);
        
        % save results
        if options.saveResultsFlag
            saveResults(obj, options.dirResults);
        end
        
        % display results
        if options.display
            handles = displayResults(obj, options);
            if options.saveFiguresFlag
                saveFigures(obj, handles, options.dirFigures);
            end
        end
    
        function options = createDefaultOptions(data)
            % Compute default options, some of them depending on data set size
            options.display         = true;
            options.showObsNames    = size(data, 1)  < 200;
            options.showVarNames    = size(data, 2) < 50;
            options.saveFiguresFlag = false;
            options.dirFigures      = pwd;
            options.saveResultsFlag = false;
            options.dirResults      = pwd;
            options.axesProperties  = {};
        end
        
        function options = parseInputArguments(options, varargin)
            % Parse input arguments and populate an "options" structure
            
            if mod(length(varargin), 2) > 0
                error('Should specify options as parameter name-value pairs');
            end
            
            while length(varargin) > 1
                paramName = varargin{1};
                switch lower(paramName)
                    case 'display'
                        options.display = parseBoolean(varargin{2});
                    case 'saveresults'
                        options.saveResultsFlag = parseBoolean(varargin{2});
                    case 'resultsdir'
                        options.dirResults = varargin{2};
                    case 'savefigures'
                        options.saveFiguresFlag = parseBoolean(varargin{2});
                    case 'figuresdir'
                        options.dirFigures = varargin{2};
                    case 'showobsnames'
                        options.showObsNames = parseBoolean(varargin{2});
                    case 'showvarnames'
                        options.showVarNames = parseBoolean(varargin{2});
                    case 'axesproperties'
                        options.axesProperties = varargin{2};
                    otherwise
                        error(['Unknown parameter name: ' paramName]);
                end
                
                varargin(1:2) = [];
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
        end
    end % end of main constructor
    
end % end constructors

%% Computation Methods
methods (Access = private)
    function computeLDA(obj, tab)
        % Compute the variance matrices, and the transformed data

        % size of data table
        data = tab.Data;
        nInds = size(data, 1);
        nVars = size(data, 2);
        
        % number of group / classes
        [uniGroups, tmp, groupIndices] = unique(obj.Group.Data); %#ok<ASGLU>
        nGroups = length(uniGroups);
        
        % recenter data
        obj.Means = mean(data);
        data = bsxfun(@minus, data, obj.Means);
        
        % find the maximal dimension
        nDims = min(nGroups-1, nVars);
        
        %% Compute the matrices of the problem
        
        % sum of squared differences (total)
        obj.SSD_T = data' * data;
        
        % initialize arrays for computing group means
        groupCounts = zeros(nGroups, 1);
        groupMeans = zeros(nGroups, nVars);
        
        % initialize the "between groups" sum of squared differences
        obj.SSD_B = zeros(nVars, nVars);
        
        % initialize the "within groups" sum of squared differences
        obj.SSD_W = zeros(nVars, nVars);
        
        % Compute matrices by iterating over groups
        for i = 1:nGroups
            inds = groupIndices == i;
            groupCounts(i) = sum(inds);
            
            % compute groupe mean
            mu_i = mean(data(inds, :));
            groupMeans(i,:) = mu_i;
            obj.SSD_B = obj.SSD_B + (mu_i' * mu_i) * groupCounts(i);
            
            % group data centered on group mean
            gdata = bsxfun(@minus, data(inds,:), mu_i);
            
            % update residual sum of square differences (within groups)
            obj.SSD_W = obj.SSD_W + gdata' * gdata;
        end

        
        %% Extraction of eigen vectors
        
        % Compute first eigen vectors
        % (function "manova1" uses a more complicated algorithm, 
        [v, ev] = eigs(obj.SSD_B, obj.SSD_W, nDims, 'largestabs');
        ev = diag(ev);

        % Re-scale eigenvectors to ensure the within-group variance is 1
        vs = diag(v' * obj.SSD_W * v)' ./ (nInds - nGroups);
        vs(vs<=0) = 1;
        v = v ./ repmat(sqrt(vs), size(v,1), 1);

        
        %% Create Result Tables
        
        % name of new columns
        varNames = strtrim(cellstr(num2str((1:nDims)', 'cc%d')));
        
        % Table object for canonical coordinates
        if ~isempty(tab.Name)
            name = sprintf('Can. Coords of %s', tab.Name);
        else
            name = 'Can. Coords';
        end
        obj.Scores = Table.create(data * v(:,1:nDims), ...
            'rowNames', tab.RowNames, ...
            'colNames', varNames, ...
            'name', name);
        
        % Table object for eigen vectors
        if ~isempty(tab.Name)
            name = sprintf('Loadings of %s', tab.Name);
        else
            name = 'Loadings';
        end
        obj.Loadings = Table.create(v(:,1:nDims), ...
            'rowNames', tab.ColNames, ...
            'colNames', varNames, ...
            'name', name);
        
        % compute array of eigen values
        eigenVals = zeros(length(ev), 3);
        eigenVals(:, 1) = ev;                       % eigen values
        eigenVals(:, 2) = 100 * ev / sum(ev);       % inertia
        eigenVals(:, 3) = cumsum(eigenVals(:,2));   % cumulated inertia
        
        % Table object for eigen values
        if ~isempty(tab.Name)
            name = sprintf('Eigen values of %s', tab.Name);
        else
            name = 'Eigen values';
        end
        obj.EigenValues = Table.create(eigenVals, ...
            'rowNames', varNames, ...
            'name', name, ...
            'colNames', {'EigenValues', 'Inertia', 'Cumulated'});
    end
end

%% Methods
methods (Access = private)
    
    function saveResults(obj, dirResults)
        % Save 3 result files corresponding to Scores, loadings and eigen values
        
        % save score array (coordinates of individuals in new basis)
        fileName = sprintf('%s-cda.scores.txt', obj.TableName);
        write(obj.Scores, fullfile(dirResults, fileName));
        
        % save loadings array (corodinates of variable in new basis)
        fileName = sprintf('%s-cda.loadings.txt', obj.TableName);
        write(obj.Loadings, fullfile(dirResults, fileName));
        
        % save eigen values array
        fileName = sprintf('%s-cda.values.txt', obj.TableName);
        write(obj.EigenValues, fullfile(dirResults, fileName));
    end

    
    function handles = displayResults(obj, options)
        % Display results of LinearDiscriminantAnalysis
        %
        % Returns a structure with fields corresponding to figure handles:
        % * screePlot
        % * scorePlot12
        % * scorePlot34
        % * loadingsPlot12
        % * loadingsPlot34
        
        
        % number of canonical components to display
        npc = size(obj.Scores.Data, 2);
        
        % Scree plot of the LinearDiscriminantAnalysis
        handles.screePlot = screePlot(obj, options.axesProperties{:});
        
        % individuals in plane CC1-CC2
        if npc >= 2
            handles.scorePlot12 = figure;
            scorePlot(obj, 1, 2, 'showNames', options.showObsNames, options.axesProperties{:});
        end
        
        % individuals in plane CC3-CC4
        if npc >= 4
            handles.scorePlot34 = figure;
            scorePlot(obj, 3, 4, 'showNames', options.showObsNames, options.axesProperties{:});
        end
        
        
        % loading plots CC1-CC2
        if npc >= 2
            handles.loadingsPlot12 = figure;
            loadingPlot(obj, 1, 2, 'showNames', options.showVarNames, options.axesProperties{:});
        end
        
        % loading plots CC3-CC4
        if npc >= 4
            handles.loadingsPlot34 = figure;
            loadingPlot(obj, 3, 4, 'showNames', options.showVarNames, options.axesProperties{:});
        end
    end
    
    function saveFigures(obj, handles, dirFigs)
        
        baseName = obj.TableName;
        
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
    function disp(obj)
        % Display a short summary about analysis result
        
        disp('Linear Discriminant Analysis Result');
        disp(['   Input data: ' obj.TableName]);
        disp(['       scores: ' sprintf('<%dx%d Table>', size(obj.Scores))]);
        disp(['     loadings: ' sprintf('<%dx%d Table>', size(obj.Loadings))]);
        disp(['  eigenValues: ' sprintf('<%dx%d Table>', size(obj.EigenValues))]);
        disp('Type ''properties(LinearDiscriminantAnalysis)'' to see all properties');
    end
end

end % end classdef

