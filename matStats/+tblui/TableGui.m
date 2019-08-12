classdef TableGui < handle
%TABLEGUI Manager of various GUI aspects (create frames, keep instances...)
%
%   Class TableGui
%
%   Example
%   TableGui
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    TextOptions = {'fontsize', 14};

    DlgListSize = [180 220];
    
end % end properties


%% Constructor
methods
    function obj = TableGui(varargin)
    % Constructor for TableGui class

    end

end % end constructors


methods
    function viewer = createTableViewer(obj, table)
        % Create a new document from image, add it to app, and display img
        
        if isempty(table)
            % in case of empty image, create an "empty view"
            viewer = tblui.TableViewer(obj, []);
            return;
        end
                
        % creates a display for the new image
        doc = tblui.TableDoc(table);
        viewer = tblui.TableViewer(obj, doc);
        
    end
end    


%% GUI Creation methods
methods
    function createFigureMenu(obj, hf, viewer) %#ok<INUSL>
        
        import tblui.actions.*;
        import tblui.actions.file.*;
        import tblui.actions.edit.*;
        import tblui.actions.plot.*;
        import tblui.actions.analysis.*;
        
        fileMenu = uimenu(hf, 'Label', 'Files');
        addMenuItem(fileMenu, OpenTable(viewer), 'Open...');

        demoMenu = uimenu(fileMenu, 'Label', 'Open Demo');
        action = OpenDemoTable(viewer, 'fisherIris.txt');
        addMenuItem(demoMenu, action, 'Fisher''s iris');
        action = OpenDemoTable(viewer, 'fleaBeetles.txt');
        addMenuItem(demoMenu, action, 'Flea Beetles');
        
        uimenu(fileMenu, 'Label', 'Close', 'Separator', 'On', ...
            'Callback', @viewer.close);
        
        tableMenu = uimenu(hf, 'Label', 'Table');
        addMenuItem(tableMenu, RenameTable(viewer), 'Rename');
        addMenuItem(tableMenu, SelectRows(viewer), 'Select Rows...');
        addMenuItem(tableMenu, SelectColumns(viewer), 'Select Columns...');
        uimenu(tableMenu, 'Label', 'Merge Rows', 'Separator', 'On', 'Enable', 'Off');
        uimenu(tableMenu, 'Label', 'Merge Columns', 'Enable', 'Off');
        

        plotMenu = uimenu(hf, 'Label', 'Plot');
        addMenuItem(plotMenu, ...
            ColumnHistogram(viewer), ...
            'Histogram');
        addMenuItem(plotMenu, PlotTable(viewer),          'Plot');
        addMenuItem(plotMenu, PlotSelectedColumns(viewer),'Plot Columns...');
        addMenuItem(plotMenu, ScatterPlot(viewer),        'Scatter Plot...');
        addMenuItem(plotMenu, ScatterGroups(viewer),      'Scatter Plot (by group)...');
        addMenuItem(plotMenu, BoxPlot(viewer),            'Box Plot', true);
        addMenuItem(plotMenu, GroupBoxPlot(viewer),       'Box Plot by Group');
        addMenuItem(plotMenu, ViolinPlot(viewer),         'Violin Plot');
        
        addMenuItem(plotMenu, PlotMatrix(viewer),         'Matrix Plot', true);
        addMenuItem(plotMenu, PlotCorrelationCircles(viewer),  'Correlation Circles');
        
        analyzeMenu = uimenu(hf, 'Label', 'Analyze');
        addMenuItem(analyzeMenu, PlotTableRows(viewer),   'Plot Rows');
        addMenuItem(analyzeMenu, TablePca(viewer),        'PCA');
        
        
        
        function item = addMenuItem(menu, action, label, varargin)
            % creates new item
            item = uimenu(menu, 'Label', label, ...
                'UserData', action, ...
                'Callback', @action.actionPerformed);
            
            % eventually add separator above item
            if ~isempty(varargin)
                var = varargin{1};
                if islogical(var)
                    set(item, 'Separator', 'On');
                end
            end
        end
    end
end

methods
    function h = addInputTextLine(obj, parent, label, text, cb)
        
        hLine = uix.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        uicontrol('Style', 'Text', ...
            'Parent', hLine, ...
            'String', label, ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        
        % creates the new control
        bgColor = getWidgetBackgroundColor(obj);
        h = uicontrol(...
            'Style', 'Edit', ...
            'Parent', hLine, ...
            'String', text, ...
            'BackgroundColor', bgColor);
        if nargin > 4
            set(h, 'Callback', cb);
        end
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-4 -6]);
    end
    
    function h = addComboBoxLine(obj, parent, label, choices, cb)
        
        hLine = uix.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        uicontrol('Style', 'Text', ...
            'Parent', hLine, ...
            'String', label, ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        
        % creates the new control
        bgColor = getWidgetBackgroundColor(obj);
        h = uicontrol('Style', 'PopupMenu', ...
            'Parent', hLine, ...
            'String', choices, ...
            'BackgroundColor', bgColor, ...
            'Value', 1);
        if nargin > 4
            set(h, 'Callback', cb);
        end
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-4 -6]);
    end
    
end


%% Graphical utilitaries Methods
methods
    function h = createPlotFigure(obj)
        % Create a new figure with standard options
        h = figure;
        clf; hold on;
        set(gca, obj.TextOptions{:});
    end
    
    function bgColor = getWidgetBackgroundColor(obj) %#ok<MANU>
        % compute background color of most widgets
        if ispc
            bgColor = 'White';
        else
            bgColor = get(0,'defaultUicontrolBackgroundColor');
        end
    end

end % end methods


end % end classdef

