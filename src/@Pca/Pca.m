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
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % The name of the input table
    tableName;
    
    % A boolean flag indicating whether the input table is scaled or not
    scaled;
    
    % the mean value of each variable. 1-by-NV
    means;

    % Table of coordinates of each individual in new coordinate system
    % NI-by-NC (NC: Number of components)
    scores;
    
    % Table of coordinates of each variable in the new coordinate system
    % NV-by-NC
    loadings;
    
    % The array of eigen values, inertia, and cumulated inertia
    % NC-by-3 

    eigenValues;
    
    % indsup;
    % varsup;
end % end properties


%% Constructor
methods
    function this = Pca(data, varargin)
        % Constructor for Pca class
        
        % copy constructor
        if isa(data, 'Pca')
            this.tableName      = data.tableName;
            this.scaled         = data.scaled;

            this.means          = data.means;
            this.scores         = Table(data.scores);
            this.loadings       = Table(data.loadings);
            this.eigenValues    = Table(data.eigenValues);
            return;
        end
        
        
        %% Parse input arguments
        
        if mod(length(varargin), 2) > 0
            error('Should specify options as parameter name-value pairs');
        end
        
        % analysis options
        scale           = true;
        
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
                case 'scale'
                    scale = varargin{2};
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
        
        if ischar(display)
            display = strcmpi(display, 'on');
        end
        

        % ensure data is a data table
        if isnumeric(data)
            data = Table(data);
            data.name = inputname(1);
        end
        
        % compute PCA results
        [m sc ld ev] = computePCA(data, scale);
        
        % keep results
        this.scaled         = scale;
        this.tableName      = data.name;
        this.means          = m;
        this.scores         = sc;
        this.loadings       = ld;
        this.eigenValues    = ev;
        
        
        
        % save results
        if saveResultsFlag
            savePcaResults(this, dirResults);
        end
        
        % display results
        if display
            hFigs = displayPcaResults(this, showObsNames, showVarNames, axesProperties);
            
            if saveFiguresFlag
                saveFigures(this, hFigs, dirFigures);
            end
        end
        
        % display correlation circle
        if display && scale
            h = displayCorrelationCircle(this, axesProperties{:});
            
            if saveFiguresFlag
                fileName = sprintf('%s-pca.cc12.png', this.tableName);
                print(h(1), fullfile(dirFigures, fileName));
                
                if ishandle(h(2))
                    fileName = sprintf('%s-pca.cc34.png', this.tableName);
                    print(h(2), fullfile(dirFigures, fileName));
                end
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


%% Methods
methods
    function b = isScaled(this)
        b = this.scaled;
    end
    
    
    function savePcaResults(this, dirResults)
        % Save 3 result files corresponding to Scores, loadings and eigen values
        
        % save score array (coordinates of individuals in new basis)
        fileName = sprintf('%s-pca.scores.txt', this.tableName);
        write(this.scores, fullfile(dirResults, fileName));
        
        % save loadings array (corodinates of variable in new basis)
        fileName = sprintf('%s-pca.loadings.txt', this.tableName);
        write(this.loadings, fullfile(dirResults, fileName));
        
        % save eigen values array
        fileName = sprintf('%s-pca.values.txt', this.tableName);
        write(this.eigenValues, fullfile(dirResults, fileName));
    end

    
    function h = displayPcaResults(this, showObsNames, showVarNames, ...
            axesProperties)
        % Display results of PCA
        
        % number of principal components to display
        npc = size(this.scores.data, 2);
        
        % Scree plot of the PCA
        h1 = figure;
        screePlot(this, axesProperties{:});
        
        % individuals in plane PC1-PC2
        h2 = figure;
        scorePlot(this, 1, 2, 'showNames', showObsNames, axesProperties{:});

        % individuals in plane PC3-PC4
        if npc >= 4
            h3 = figure;
            scorePlot(this, 3, 4, 'showNames', showObsNames, axesProperties{:});
        else
            h3 = -1;
        end
        
        
        % loading plots PC1-PC2
        h4 = figure;
        loadingPlot(this, 1, 2, 'showNames', showVarNames, axesProperties{:});
        
        % loading plots PC3-PC4
        if npc >= 4
            h5 = figure;
            loadingPlot(this, 3, 4, 'showNames', showVarNames, axesProperties{:});
        end
        
        % return handle array to figures
        h = [h1 h2 h3 h4 h5];
    end
    
    function saveFigures(this, hFigs, dirFigs)
        
        baseName = this.tableName;
        
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
    end
    

    function h = displayCorrelationCircle(this, varargin)
        
        name = this.tableName;
        values = this.eigenValues.data;
        
        nv = size(this.scores, 2);
        correl = zeros(nv, nv);
        for i = 1:nv
            correl(:,i) = sqrt(values(i)) * this.loadings.data(1:nv,i);
        end

        correl = Table.create(correl, ...
            'rowNames', this.loadings.rowNames(1:nv), ...
            'name', name, ...
            'colNames', this.loadings.colNames);
        
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

methods
    function disp(this)
        
        if this.scaled
            scaleString = 'true';
        else
            scaleString = 'false';
        end
        
        disp('Principal Component Analysis Result');
        disp(['   Input data: ' this.tableName]);
        disp(['       scaled: ' scaleString]);
        disp(['        means: ' sprintf('<%dx%d double>', size(this.means))]);
        disp(['       scores: ' sprintf('<%dx%d Table>', size(this.scores))]);
        disp(['     loadings: ' sprintf('<%dx%d Table>', size(this.loadings))]);
        disp(['  eigenValues: ' sprintf('<%dx%d Table>', size(this.eigenValues))]);
        
    end
end

end % end classdef

