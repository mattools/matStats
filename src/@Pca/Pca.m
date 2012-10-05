classdef Pca < handle
%PCA  Performs a Principal Components Analysis
%
%   RES = pca(TAB);
%   Performs Principal Components Analysis (PCA) of the data in table TAB
%   with N rows and P columns, and returns the result in a data structures
%   with following fields:
%     scores        the new coordinates of individuals, as N-by-P array
%     loadings      the loadinds (or coefficients) of PCA, as P-by-P array
%     eigenValues   values of inertia, inertia percent and cumulated inertia
%     means         the mean value of each column of original data array
%   
%   res = pca(TAB, PARAM, VALUE);
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
%   'axesProperties' a cell array of parameter name-value pairs, that will
%       be applied to each new created figure.
%
%   Example
%     % Principal component Analysis of Fisher's iris
%     iris = Table.read('fisherIris');
%     res = Pca(iris(:,1:4));
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    tableName;
    scaled;
    
    means;
    scores;
    loadings;
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
            this.tableName  = data.tableName;
            this.scaled     = data.scaled;

            this.means      = data.means;
            this.scores     = data.scores;
            this.loadings   = data.loadings;
            this.eigenValues     = data.eigenValues;
            return;
        end
        
        
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
        axesProperties  = {};
        
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
        end
        
        [m sc ld ev] = computePCA(data, scale);
        
        % keep results
        this.scaled     = scale;
        this.tableName  = data.name;
        this.means      = m;
        this.scores     = sc;
        this.loadings   = ld;
        this.eigenValues = ev;
        
        
        
        % save results
        if saveResultsFlag
            savePcaResults(this, dirResults);
        end
        
        % display results
        if display
            hFigs = displayPcaResults(this, showNames, axesProperties);
            
            if saveFiguresFlag
                saveFigures(this, hFigs, dirFigures);
            end
        end
        
        % display correlation circle
        if display && scale
            h = displayCorrelationCircle(this, axesProperties);
            
            if saveFiguresFlag
                fileName = sprintf('%s-pca.cc12.png', this.tableName);
                print(h(1), fullfile(dirFigures, fileName));
                
                if ishandle(h(2))
                    fileName = sprintf('%s-pca.cc34.png', this.tableName);
                    print(h(2), fullfile(dirFigures, fileName));
                end
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

    
    function h = displayPcaResults(this, showNames, axesProperties)
        % Display results of PCA
        
        % extract data
        name = this.tableName;
        coord = this.scores.data;
        values = this.eigenValues.data;
        
        % distribution of the first 10 eigen values
        h1 = figure('Name', 'PCA - Eigen Values', 'NumberTitle', 'off');
        if ~isempty(axesProperties)
            set(gca, axesProperties{:});
        end
        
        nx = min(10, size(coord, 2));
        plot(1:nx, values(1:nx, 2));
        xlim([1 nx]);
        xlabel('Number of components');
        ylabel('Inertia (%)');
        title([name ' - eigen values'], 'interpreter', 'none');
        
        % individuals in plane PC1-PC2
        h2 = figure('Name', 'PCA - Comp. 1 and 2', 'NumberTitle', 'off');
        if ~isempty(axesProperties)
            set(gca, axesProperties{:});
        end
        
        x = coord(:, 1);
        y = coord(:, 2);
        if showNames
            drawText(x, y, this.scores.rowNames);
        else
            plot(x, y, '.k');
        end
        
        xlabel(sprintf('Principal component 1 (%5.2f)', values(1, 2)));
        ylabel(sprintf('Principal component 2 (%5.2f)', values(2, 2)));
        title(name, 'interpreter', 'none');
        
        % individuals in plane PC3-PC4
        if size(coord, 2) >= 4
            h3 = figure('Name', 'PCA - Comp. 3 and 4', 'NumberTitle', 'off');
            if ~isempty(axesProperties)
                set(gca, axesProperties{:});
            end
            
            x = coord(:, 3);
            y = coord(:, 4);
            
            if showNames
                drawText(x, y, this.scores.rowNames);
            else
                plot(x, y, '.k');
            end
            
            xlabel(sprintf('Principal component 3 (%5.2f)', values(3, 2)));
            ylabel(sprintf('Principal component 4 (%5.2f)', values(4, 2)));
            title(name, 'interpreter', 'none');
        else
            h3 = -1;
        end
        
        
        % loading plots PC1-PC2
        h4 = figure('Name', 'PCA Variables - Coords 1 and 2', 'NumberTitle', 'off');
        if ~isempty(axesProperties)
            set(gca, axesProperties{:});
        end
        
        drawText(this.loadings.data(:, 1), this.loadings.data(:,2), this.loadings.rowNames, ...
            'HorizontalAlignment', 'Center');
        
        xlabel(sprintf('Principal component 1 (%5.2f)', values(1, 2)));
        ylabel(sprintf('Principal component 2 (%5.2f)', values(2, 2)));
        title(name, 'interpreter', 'none');
        
        
        % loading plots PC1-PC2
        if size(coord, 2) >= 4
            h5 = figure('Name', 'PCA Variables - Coords 3 and 4', 'NumberTitle', 'off');
            if ~isempty(axesProperties)
                set(gca, axesProperties{:});
            end
            
            drawText(this.loadings.data(:, 3), this.loadings.data(:,4), this.loadings.rowNames, ...
                'HorizontalAlignment', 'Center');
            
            xlabel(sprintf('Principal component 3 (%5.2f)', values(3, 2)));
            ylabel(sprintf('Principal component 4 (%5.2f)', values(4, 2)));
            title(name, 'interpreter', 'none');
        end
        
        % return handle array to figures
        h = [h1 h2 h3 h4 h5];
    end
    
    function varargout = scorePlot(this, cp1, cp2, varargin) 
        % individuals in plane PC1-PC2
        
        if nargin < 3 || ischar(cp1)
            cp1 = 1;
            cp2 = 2;
        end
        
        % extract display options
        showNames = true;
        for i = 1:2:(length(varargin)-1)
            if strncmp('showNames', varargin{i})
                showNames = varargin{i+1};
                varargin(i:i+1) = [];
                break;
            end
        end
        
        % create new figure
        str = sprintf('PCA - Comp. %d and %d', cp1, cp2);
        h = figure('Name', str, 'NumberTitle', 'off');
        if ~isempty(varargin)
            set(gca, varargin{:});
        end
        
        % score coordinates
        x = this.scores(:, cp1).data;
        y = this.scores(:, cp2).data;
        
        % display either names or dots
        if showNames
            drawText(x, y, this.scores.rowNames);
        else
            plot(x, y, '.k');
        end
        
        % create legends
        vl1 = this.eigenValues(cp1, 2).data;
        vl2 = this.eigenValues(cp2, 2).data;
        xlabel(sprintf('Principal component %d (%5.2f %%)', cp1, vl1));
        ylabel(sprintf('Principal component %d (%5.2f %%)', cp2, vl2));
        title(this.tableName, 'interpreter', 'none');
        
        if nargout > 0
            varargout = {h};
        end
    end
    
    function varargout = loadingPlot(this, cp1, cp2, varargin)
        % loading plot in plane PC1-PC2
        
        if nargin < 3 || ischar(cp1)
            cp1 = 1;
            cp2 = 2;
        end
        
        % extract display options
        showNames = true;
        for i = 1:2:(length(varargin)-1)
            if strncmp('showNames', varargin{i})
                showNames = varargin{i+1};
                varargin(i:i+1) = [];
                break;
            end
        end
        
        % create new figure
        str = sprintf('PCA Variable - Comp. %d and %d', cp1, cp2);
        h = figure('Name', str, 'NumberTitle', 'off');
        if ~isempty(varargin)
            set(gca, varargin{:});
        end
        
        % score coordinates
        x = this.loadings(:, cp1).data;
        y = this.loadings(:, cp2).data;
        
        % display either names or dots
        if showNames
            drawText(x, y, this.loadings.rowNames);
        else
            plot(x, y, '.k');
        end
        
        % create legends
        vl1 = this.eigenValues(cp1, 2).data;
        vl2 = this.eigenValues(cp2, 2).data;
        xlabel(sprintf('Principal component %d (%5.2f %%)', cp1, vl1));
        ylabel(sprintf('Principal component %d (%5.2f %%)', cp2, vl2));
        title(this.tableName, 'interpreter', 'none');
        
        if nargout > 0
            varargout = {h};
        end
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
    

    function h = displayCorrelationCircle(this, axesProperties)
        
        name = this.tableName;
        values = this.eigenValues.data;
        
        nv = size(this.scores, 2);
        correl = zeros(nv, nv);
        for i = 1:nv
            correl(:,i) = sqrt(values(i)) * this.loadings(:,i).data;
        end

        correl = Table.create(correl, ...
            'rowNames', this.loadings.rowNames, ...
            'name', name, ...
            'colNames', this.loadings.colNames);
        
        % correlation plot PC1-PC2
        h1 = figure('Name', 'PCA Correlation Circle - Coords 1 and 2', ...
            'NumberTitle', 'off');
        if ~isempty(axesProperties)
            set(gca, axesProperties{:});
        end
        
        drawText(correl.data(:, 1), correl.data(:,2), correl.rowNames, ...
            'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
        hold on; 
        plot(correl.data(:, 1), correl.data(:,2), '.');
        makeCircleAxis;
        
        xlabel(sprintf('Principal component 1 (%5.2f)', values(1, 2)));
        ylabel(sprintf('Principal component 2 (%5.2f)', values(2, 2)));
        title(name, 'interpreter', 'none');
        
        % correlation plot PC1-PC2
        if size(correl, 2) >= 4
            h2 = figure('Name', 'PCA Correlation Circle - Coords 3 and 4', ...
                'NumberTitle', 'off');
            if ~isempty(axesProperties)
                set(gca, axesProperties{:});
            end
            
            drawText(correl.data(:, 3), correl.data(:,4), correl.rowNames, ...
                'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
            hold on; plot(correl.data(:, 3), correl.data(:,4), '.');
            makeCircleAxis;
            
            xlabel(sprintf('Principal component 3 (%5.2f)', values(3, 2)));
            ylabel(sprintf('Principal component 4 (%5.2f)', values(4, 2)));
            title(name, 'interpreter', 'none');
            
        else
            h2 = -1;
        end
        
        h = [h1 h2];
    end

    function varargout = correlationCircle(this, cp1, cp2, varargin)
        % Plot correlation circle in plane given by two PC
        
        if nargin < 3 || ischar(cp1)
            cp1 = 1;
            cp2 = 2;
        end
        
        % extract display options
        showNames = true;
        for i = 1:2:(length(varargin)-1)
            if strncmp('showNames', varargin{i})
                showNames = varargin{i+1};
                varargin(i:i+1) = [];
                break;
            end
        end
        
        % create new figure
        str = sprintf('PCA Correlation Circle - Comp. %d and %d', cp1, cp2);
        h = figure('Name', str, 'NumberTitle', 'off');
        if ~isempty(varargin)
            set(gca, varargin{:});
        end
        
        name = this.tableName;
        values = this.eigenValues.data;
        
        % Create the correlation table
        nv = size(this.scores, 2);
        correl = zeros(nv, nv);
        for i = 1:nv
            correl(:,i) = sqrt(values(i)) * this.loadings(:,i).data;
        end

        correl = Table.create(correl, ...
            'rowNames', this.loadings.rowNames, ...
            'name', name, ...
            'colNames', this.loadings.colNames);
        
        
        % score coordinates
        x = correl(:, cp1).data;
        y = correl(:, cp2).data;
        
        % display either names or dots
        if showNames
            drawText(x, y, correl.rowNames, ...
                'HorizontalAlignment', 'Center', ...
                'VerticalAlignment', 'Bottom');
        end
        
        hold on; 
        plot(x, y, '.');
        makeCircleAxis;
        
        % create legends
        vl1 = this.eigenValues(cp1, 2).data;
        vl2 = this.eigenValues(cp2, 2).data;
        xlabel(sprintf('Principal component %d (%5.2f %%)', cp1, vl1));
        ylabel(sprintf('Principal component %d (%5.2f %%)', cp2, vl2));
        title(this.tableName, 'interpreter', 'none');
        
        if nargout > 0
            varargout = {h};
        end
    end
    
end % end methods


end % end classdef

