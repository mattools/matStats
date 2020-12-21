classdef (InferiorClasses = {?matlab.graphics.axis.Axes}) Pca < handle
% Performs a Principal Components Analysis.
%
%   RES = Pca(TAB);
%   Performs Principal Components Analysis (PCA) of the data table TAB with
%   N rows and P columns, and returns the result in a new instance of Pca
%   class with following fields:
%     Scores        the new coordinates of individuals, as N-by-P array
%     Loadings      the loadinds (or coefficients) of PCA, as P-by-P array
%     EigenValues   values of inertia, inertia percent and cumulated inertia
%     Scaled        the boolean indicating whether the analysis was scaled
%     Means         the mean value of each column of original data array
%     Scalings      the scalings associated to each column of original data
%                   array, if the PCA was scaled.
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
% e-mail: david.legland@inrae.fr
% Created: 2012-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % The name of the input table
    TableName;
    
    % A boolean flag indicating whether the input table is scaled or not
    Scaled;
    
    % The mean value of each variable, as 1-by-NV Table object.
    Means;

    % The scaling applied to each variable, as 1-by-NV Table object.
    Scalings;

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
    function obj = Pca(varargin)
        % Constructor for Pca class.
        
        % copy constructor
        if nargin == 1 && isa(varargin{1}, 'Pca')
            pca = varargin{1};
            % copy computation options
            obj.Scaled         = pca.Scaled;

            % copy table data
            obj.TableName      = pca.TableName;
            obj.Means          = pca.Means;
            obj.Scalings       = pca.Scalings;
            
            % copy computation results
            obj.Scores         = Table(pca.Scores);
            obj.Loadings       = Table(pca.Loadings);
            obj.EigenValues    = Table(pca.EigenValues);
            return;
        end
        
        
        %% Initialize raw data
        
        % if first argument is a table or an array, use it as data.
        data = [];
        if nargin > 0
            var1 = varargin{1};
            if isnumeric(var1)
                data = Table(var1);
                varargin(1) = [];
            elseif isa(var1, 'Table')
                data = var1;
                varargin(1) = [];
            end
            
            if ~isempty(data)
                % ensure data table has a valid name
                if isempty(data.Name)
                    data.Name = inputname(1);
                end
            end
        end
        
        
        %% Parse input arguments
        
        if mod(length(varargin), 2) > 0
            error('Should specify options as parameter name-value pairs');
        end
        
        % Parse input arguments
        options = createDefaultOptions(data);
        options = parseInputArguments(options, varargin{:});

        % analysis options
        obj.Scaled = options.Scale;
        
        if isempty(data)
            return;
        end
        
        % Intialize PCA results
        computePCA(obj, data);
        
        % save results
        if options.SaveResultsFlag
            savePcaResults(obj, options.DirResults);
        end
        
        % display results
        if options.Display
            handles = displayPcaResults(obj, options);
            
            if options.SaveFiguresFlag
                saveFigures(obj, handles, options.DirFigures);
            end
        end
        
        % display correlation circle
        if options.Display && obj.Scaled
            h = displayCorrelationCircle(obj, options.AxesProperties{:});
            
            if options.SaveFiguresFlag
                fileName = sprintf('%s-pca.cc12.png', obj.TableName);
                print(h(1), fullfile(options.DirFigures, fileName), '-dpng');
                
                if ishandle(h(2))
                    fileName = sprintf('%s-pca.cc34.png', obj.TableName);
                    print(h(2), fullfile(options.DirFigures, fileName), '-dpng');
                end
            end
        end

        function options = createDefaultOptions(data)
            % Compute default options, some of them depending on data set size
            options.Scale           = true;
            options.Display         = true;
            options.ShowObsNames    = size(data, 1) < 200;
            options.ShowVarNames    = size(data, 2) < 50;
            options.SaveFiguresFlag = false;
            options.DirFigures      = pwd;
            options.SaveResultsFlag = false;
            options.DirResults      = pwd;
            options.AxesProperties  = {};
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
                        options.Scale = parseBoolean(varargin{2});
                    case 'display'
                        options.Display = parseBoolean(varargin{2});
                    case 'saveresults'
                        options.SaveResultsFlag = parseBoolean(varargin{2});
                    case 'resultsdir'
                        options.DirResults = varargin{2};
                    case 'savefigures'
                        options.SaveFiguresFlag = parseBoolean(varargin{2});
                    case 'figuresdir'
                        options.DirFigures = varargin{2};
                    case 'showobsnames'
                        options.ShowObsNames = parseBoolean(varargin{2});
                    case 'showvarnames'
                        options.ShowVarNames = parseBoolean(varargin{2});
                    case 'axesproperties'
                        options.AxesProperties = varargin{2};
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
    
    computePca(obj);

    function savePcaResults(obj, dirResults)
        % Save 3 result files corresponding to Scores, loadings and eigen values
        
        % save score array (coordinates of individuals in new basis)
        fileName = sprintf('%s-pca.Scores.txt', obj.TableName);
        write(obj.Scores, fullfile(dirResults, fileName));
        
        % save loadings array (corodinates of variable in new basis)
        fileName = sprintf('%s-pca.Loadings.txt', obj.TableName);
        write(obj.Loadings, fullfile(dirResults, fileName));
        
        % save eigen values array
        fileName = sprintf('%s-pca.values.txt', obj.TableName);
        write(obj.EigenValues, fullfile(dirResults, fileName));
    end

    
    function handles = displayPcaResults(obj, options)
        % Display results of PCA
        %
        % Returns a structure with fields corresponding to figure handles:
        % * ScreePlot
        % * ScorePlot12
        % * ScorePlot34
        % * LoadingsPlot12
        % * LoadingsPlot34
        
        % number of principal components to display
        npc = size(obj.Scores.Data, 2);
        
        % Scree plot of the PCA
        handles.ScreePlot = screePlot(obj, options.AxesProperties{:});
       
        % individuals in plane PC1-PC2
        if npc >= 2
            handles.ScorePlot12 = figure;
            scorePlot(obj, 1, 2, 'showNames', options.ShowObsNames, options.AxesProperties{:});
        end
        
        % individuals in plane PC3-PC4
        if npc >= 4
            handles.ScorePlot34 = figure;
            scorePlot(obj, 3, 4, 'showNames', options.ShowObsNames, options.AxesProperties{:});
        end
        
        % loading plots PC1-PC2
        if npc >= 2
            handles.LoadingsPlot12 = figure;
            loadingPlot(obj, 1, 2, 'showNames', options.ShowVarNames, options.AxesProperties{:});
        end
        
        % loading plots PC3-PC4
        if npc >= 4
            handles.loadingsPlot34 = figure;
            loadingPlot(obj, 3, 4, 'showNames', options.ShowVarNames, options.AxesProperties{:});
        end
    end
    
    function saveFigures(obj, handles, dirFigs)
        
        baseName = obj.TableName;
        
        fileName = sprintf('%s-pca.ev.png', baseName);
        print(handles.ScreePlot, fullfile(dirFigs, fileName), '-dpng');
        
        if isfield(handles, 'scorePlot12')
            fileName = sprintf('%s-pca.sc12.png', baseName);
            print(handles.ScorePlot12, fullfile(dirFigs, fileName), '-dpng');
        end
        
        if isfield(handles, 'scorePlot34')
            fileName = sprintf('%s-pca.sc34.png', baseName);
            print(handles.ScorePlot34, fullfile(dirFigs, fileName), '-dpng');
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
    

    function h = displayCorrelationCircle(obj, varargin)
        
        name = obj.TableName;
        values = obj.EigenValues.Data;
        
        nv = size(obj.Scores, 2);
        correl = zeros(nv, nv);
        for i = 1:nv
            correl(:,i) = sqrt(values(i)) * obj.Loadings.Data(1:nv,i);
        end

        correl = Table.create(correl, ...
            'RowNames', obj.Loadings.RowNames(1:nv), ...
            'Name', name, ...
            'ColNames', obj.Loadings.ColNames);
        
        % correlation plot PC1-PC2
        h1 = figure;
        correlationCircle(obj, 1, 2, varargin{:});
        
        % correlation plot PC3-PC4
        if size(correl, 2) >= 4
            h2 = figure;
            correlationCircle(obj, 3, 4, varargin{:});            
        else
            h2 = -1;
        end
        
        h = [h1 h2];
    end


end % end methods

%% General methods
methods
    function b = isScaled(obj)
        b = obj.Scaled;
    end
    
    function disp(obj)
        
        if obj.Scaled
            scaleString = 'true';
        else
            scaleString = 'false';
        end
        
        disp('Principal Component Analysis Result');
        disp(['   Input data: ' obj.TableName]);
        disp(['       Scaled: ' scaleString]);
        disp(['        Means: ' sprintf('<%dx%d Table>', size(obj.Means))]);
        disp(['     Scalings: ' sprintf('<%dx%d Table>', size(obj.Scalings))]);
        disp(['       Scores: ' sprintf('<%dx%d Table>', size(obj.Scores))]);
        disp(['     Loadings: ' sprintf('<%dx%d Table>', size(obj.Loadings))]);
        disp(['  EigenValues: ' sprintf('<%dx%d Table>', size(obj.EigenValues))]);
    end
end

end % end classdef

