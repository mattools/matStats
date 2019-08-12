classdef CorrelationCirclePlotAction < handle
%CORRELATIONCIRCLEPLOTACTION Plot Correlation circle of a PCA result
%
%   Class CorrelationCirclePlotAction
%
%   Example
%   CorrelationCirclePlotAction
%
%   See also
%   PcaDialog
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % The parent instance of PcaDialog
    Parent;
    
    Handles;
    
end % end properties


%% Constructor
methods
    function obj = CorrelationCirclePlotAction(pcaDlg)
    % Constructor for ScorePlotAction class
        obj.Parent = pcaDlg;
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        
        if ~obj.Parent.ValidFlag
            return;
        end
        
        createFigure(obj);
        obj.Handles.PlotAxis = -1;
    end
    
    function hf = createFigure(obj)
        
        scores = obj.Parent.ResPca.Scores;
        gui = obj.Parent.Gui;
        varNames = scores.ColNames;
        
        % creates the figure
        hf = figure(...
            'Name', 'Corelation Circle Plot Options', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        obj.Handles.Figure = hf;
        
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 230];
        set(hf, 'Position', pos);
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VButtonBox('Parent', vb);
        set(mainPanel, 'ButtonSize', [230 35], 'VerticalAlignment', 'top');
        
        % combo box for the variables to use
        obj.Handles.XAxisCombo = addComboBoxLine(gui, mainPanel, ...
            'X-Axis:', varNames);
        set(obj.Handles.XAxisCombo, 'value', 1);
        
        % combo box for the variables to use
        obj.Handles.YAxisCombo = addComboBoxLine(gui, mainPanel, ...
            'Y-Axis:', varNames);
        set(obj.Handles.YAxisCombo, 'value', 2);
        
%         % check box for displaying names or not
%         nValues = size(obj.Parent.ResPca.scores, 1);
%         obj.Handles.showNamesCheckbox = uicontrol(...
%             'Style', 'CheckBox', ...
%             'Parent', mainPanel, ...
%             'String', sprintf('Show Names (%d)', nValues) , ...
%             'Value', nValues < 200);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Apply', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Close', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end
    
    function closeFigure(obj, varargin)       
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
       
end % end methods

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)

        % handle to the main PCA object
        pca = obj.Parent.ResPca;

        % extract options from dialog
        indX = get(obj.Handles.XAxisCombo, 'value');
        indY = get(obj.Handles.YAxisCombo, 'value');
%         showNames = get(obj.Handles.showNamesCheckbox, 'value');
        
        % Check figure
        if ~ishandle(obj.Handles.PlotAxis)
            figure;
            obj.Handles.PlotAxis = axes;
        end

        % plot loadings of current PCA
        ax = obj.Handles.PlotAxis;
        correlationCircle(ax, pca, indX, indY);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end

end % end classdef

