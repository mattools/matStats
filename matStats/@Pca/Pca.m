classdef Pca < handle
%PCA  Performs a Principal Components Analysis
%
%   RES = Pca(TAB);
%   Performs Principal Components Analysis (PCA) of the data table TAB with
%   N rows and P columns, and returns the result in a new instance of Pca
%   class with following fields:
%     scores        the new coordinates of individuals, as N-by-P array
%     loadings      the loadinds (or coefficients) of PCA, as P-by-P array
%     eigenValues   values of inertia, inertia percent and cumulated inertia
%     means         the mean value of each column of original data array
%   
%   res = Pca(TAB, PARAM, VALUE);
%   Specified some processing options using parameter name-value pairs.
%   Available options are: 
%
%   'scale'     boolean flag indicating whether the data array should be
%               scaled (the default) or not. If data are scaled, they are
%               divided by their standard deviation.
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
%     res = Pca(iris(:,1:4));
%
%     % Principal component Analysis on Decathlon data
%     tab = Table.read('decathlon');
%     resPca = Pca(tab(:,1:10));
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
    
    % A boolean flag indicating whether the input table is scaled or not
    Scaled;
    
    % the mean value of each variable. 1-by-NV
    Means;

    % Table of coordinates of each individual in new coordinate system
    % NI-by-NC (NC: Number of components)
    Scores;
    
    % Table of coordinates of each variable in the new coordinate system
    % NV-by-NC
    Loadings;
    
    % The array of eigen values, inertia, and cumulated inertia
    % NC-by-3 

    EigenValues;
    
    % indsup;
    % varsup;
end % end properties


%% Constructor
methods
    function this = Pca(data, varargin)
        % Constructor for Pca class

        % avoid empty constructor
        if nargin == 0
            error('Pca requires at least one input argument');
        end
        
        % copy constructor
        if isa(data, 'Pca')
            this.TableName      = data.TableName;
            this.Scaled         = data.Scaled;

            this.Means          = data.Means;
            this.Scores         = Table(data.Scores);
            this.Loadings       = Table(data.Loadings);
            this.EigenValues    = Table(data.EigenValues);
            return;
        end
        
        
        %% Initialize raw data
        
        % ensure data is a data table
        if isnumeric(data)
            data = Table(data);
        end
        
        % ensure data table has a valid name
        if isempty(data.Name)
            data.Name = inputname(1);
        end
        
        
        %% Parse input arguments
        
        if mod(length(varargin), 2) > 0
            error('Should specify options as parameter name-value pairs');
        end
        
        % Parse input arguments
        options = createDefaultOptions(data);
        options = parseInputArguments(options, varargin{:});

        % analysis options
        scale               = options.scale;
        this.Scaled         = scale;
        
        % compute PCA results
        [m, sc, ld, ev] = computePCA(data, scale);
        
        % keep results
        this.TableName      = data.Name;
        this.Means          = m;
        this.Scores         = sc;
        this.Loadings       = ld;
        this.EigenValues    = ev;
        
        % save results
        if options.saveResultsFlag
            savePcaResults(this, options.dirResults);
        end
        
        % display results
        if options.display
            handles = displayPcaResults(this, options);
            
            if options.saveFiguresFlag
                saveFigures(this, handles, options.dirFigures);
            end
        end
        
        % display correlation circle
        if options.display && scale
            h = displayCorrelationCircle(this, options.axesProperties{:});
            
            if options.saveFiguresFlag
                fileName = sprintf('%s-pca.cc12.png', this.TableName);
                print(h(1), fullfile(options.dirFigures, fileName), '-dpng');
                
                if ishandle(h(2))
                    fileName = sprintf('%s-pca.cc34.png', this.TableName);
                    print(h(2), fullfile(options.dirFigures, fileName), '-dpng');
                end
            end
        end

        function options = createDefaultOptions(data)
            % Compute default options, some of them depending on data set size
            options.scale           = true;
            options.display         = true;
            options.showObsNames    = size(data, 1) < 200;
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
                    case 'scale'
                        options.scale = parseBoolean(varargin{2});
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


%% Private Methods (used at contruction)
methods (Access = private)
    
    function savePcaResults(this, dirResults)
        % Save 3 result files corresponding to Scores, loadings and eigen values
        
        % save score array (coordinates of individuals in new basis)
        fileName = sprintf('%s-pca.Scores.txt', this.TableName);
        write(this.Scores, fullfile(dirResults, fileName));
        
        % save loadings array (corodinates of variable in new basis)
        fileName = sprintf('%s-pca.Loadings.txt', this.TableName);
        write(this.Loadings, fullfile(dirResults, fileName));
        
        % save eigen values array
        fileName = sprintf('%s-pca.values.txt', this.TableName);
        write(this.EigenValues, fullfile(dirResults, fileName));
    end

    
    function handles = displayPcaResults(this, options)
        % Display results of PCA
        %
        % Returns a structure with fields corresponding to figure handles:
        % * screePlot
        % * scorePlot12
        % * scorePlot34
        % * loadingsPlot12
        % * loadingsPlot34
        
        % number of principal components to display
        npc = size(this.Scores.Data, 2);
        
        % Scree plot of the PCA
        handles.screePlot = screePlot(this, options.axesProperties{:});
       
        % individuals in plane PC1-PC2
        if npc >= 2
            handles.scorePlot12 = figure;
            scorePlot(this, 1, 2, 'showNames', options.showObsNames, options.axesProperties{:});
        end
        
        % individuals in plane PC3-PC4
        if npc >= 4
            handles.scorePlot34 = figure;
            scorePlot(this, 3, 4, 'showNames', options.showObsNames, options.axesProperties{:});
        end
        
        % loading plots PC1-PC2
        if npc >= 2
            handles.loadingsPlot12 = figure;
            loadingPlot(this, 1, 2, 'showNames', options.showVarNames, options.axesProperties{:});
        end
        
        % loading plots PC3-PC4
        if npc >= 4
            handles.loadingsPlot34 = figure;
            loadingPlot(this, 3, 4, 'showNames', options.showVarNames, options.axesProperties{:});
        end
    end
    
    function saveFigures(this, handles, dirFigs)
        
        baseName = this.TableName;
        
        fileName = sprintf('%s-pca.ev.png', baseName);
        print(handles.screePlot, fullfile(dirFigs, fileName), '-dpng');
        
        if isfield(handles, 'scorePlot12')
            fileName = sprintf('%s-pca.sc12.png', baseName);
            print(handles.scorePlot12, fullfile(dirFigs, fileName), '-dpng');
        end
        
        if isfield(handles, 'scorePlot34')
            fileName = sprintf('%s-pca.sc34.png', baseName);
            print(handles.scorePlot34, fullfile(dirFigs, fileName), '-dpng');
        end
        
        if isfield(handles, 'loadingsPlot12')
            fileName = sprintf('%s-pca.ld12.png', baseName);
            print(handles.LoadingsPlot12, fullfile(dirFigs, fileName), '-dpng');
        end
        
        if isfield(handles, 'loadingsPlot34')
            fileName = sprintf('%s-pca.ld34.png', baseName);
            print(handles.LoadingsPlot34, fullfile(dirFigs, fileName), '-dpng');
        end
    end
    

    function h = displayCorrelationCircle(this, varargin)
        
        name = this.TableName;
        values = this.EigenValues.Data;
        
        nv = size(this.Scores, 2);
        correl = zeros(nv, nv);
        for i = 1:nv
            correl(:,i) = sqrt(values(i)) * this.Loadings.Data(1:nv,i);
        end

        correl = Table.create(correl, ...
            'RowNames', this.Loadings.RowNames(1:nv), ...
            'Name', name, ...
            'ColNames', this.Loadings.ColNames);
        
        % correlation plot PC1-PC2
        h1 = figure;
        correlationCircle(this, 1, 2, varargin{:});
        
        % correlation plot PC3-PC4
        if size(correl, 2) >= 4
            h2 = figure;
            correlationCircle(this, 3, 4, varargin{:});            
        else
            h2 = -1;
        end
        
        h = [h1 h2];
    end


end % end methods

%% General methods
methods
    function b = isScaled(this)
        b = this.Scaled;
    end
    
    function disp(this)
        
        if this.Scaled
            scaleString = 'true';
        else
            scaleString = 'false';
        end
        
        disp('Principal Component Analysis Result');
        disp(['   Input data: ' this.TableName]);
        disp(['       scaled: ' scaleString]);
        disp(['        means: ' sprintf('<%dx%d double>', size(this.Means))]);
        disp(['       scores: ' sprintf('<%dx%d Table>', size(this.Scores))]);
        disp(['     loadings: ' sprintf('<%dx%d Table>', size(this.Loadings))]);
        disp(['  eigenValues: ' sprintf('<%dx%d Table>', size(this.EigenValues))]);
    end
end

end % end classdef

