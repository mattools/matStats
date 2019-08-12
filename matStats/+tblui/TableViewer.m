classdef TableViewer < handle
%TABLEVIEWER Frame that display the content of a Data Table
%
%   VIEWER = TableViewer(GUI, DOC);
%   Requires an instance of TableGui, and a valid TableDoc for being
%   initialised.
%
%   Example
%     viewer = TableViewer(gui, doc);
%
%   See also
%     Table, TableDoc
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % the parent GUI
    Gui;
    
    % list of handles to the various gui items
    Handles;
    
    % the table document
    Doc;
    
    % selected indices, if any
    SelectedIndices = [];
%  
%     TextOptions = {'FontSize', 14};
% 
%     DlgListSize = [160 200];

 end % end properties


%% Constructor
methods
    function obj = TableViewer(gui, doc)
    % Constructor for TableViewer class

        % call parent constructor to initialize members
        obj = obj@handle();
        
        obj.Gui = gui;
        if nargin > 1 
            if ~isempty(doc) && ~isa(doc, 'tblui.TableDoc')
                error('Second Input must be an instance of TableDoc');
            end
            obj.Doc = doc;
        end
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'HandleVisibility', 'On', ...
            'Name', 'Table Viewer', ...
            'CloseRequestFcn', @obj.close);
        
        % create main figure menu
        createFigureMenu(gui, fig, obj);
        if ~isempty(obj.Doc)
            setupLayout(fig);
        end
        
        obj.Handles.Figure = fig;
        
        updateTitle(obj);
        
        
        function setupLayout(hf)
            
            table = obj.Doc.Table;
            
            % format table data
            if ~hasFactors(table)
                % create a numeric data table
                data = table.Data;
                
            else
                % if data table has factor columns, need to convert data array
                data = num2cell(table.Data);
                indLevels = find(~cellfun(@isnumeric, table.Levels));
                for i = indLevels
                    data(:,i) = table.Levels{i}(table.Data(:, i));
                end
                
            end
            
%             % create a default context menu
%             hMenu = uicontextmenu;
%             uimenu(hMenu, 'Label', 'Hello!');
%             uimenu(hMenu, 'Label', 'Action 1');
%             uimenu(hMenu, 'Label', 'Action 2');
            
            % add a uitable component
            ht = uitable(hf, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Data', data,...
                'ColumnName', table.ColNames,...
                'RowName', table.RowNames, ...
                'ColumnEditable', false, ...
                ... 'UIContextMenu', hMenu, ...
                'CellSelectionCallback', @obj.onCellSelected, ...
                'CellEditCallback', @obj.onCellEdited);

            obj.Handles.Uitable = ht;
            
%             % additional table configuration for selection rows or columns
%             hJScroll = findjobj(ht);
%             hJTable = hJScroll.getViewport.getView;
%             hJTable.setNonContiguousCellSelection(false);
%             hJTable.setColumnSelectionAllowed(true);
%             hJTable.setRowSelectionAllowed(true);
            
            drawnow;
        end
        
    end

end % end constructors


%% Methods
methods
    function updateTitle(obj)
        % extract table infos
        if isempty(obj.Doc)
            return;
        end
        
        table = obj.Doc.Table;
        nr = size(table.Data, 1);
        nc = size(table.Data, 2);
        
        % create figure name
        pattern = '%s%s (%d-by-%d Data Table)';
        if obj.Doc.Modified
            modif = '*';
        else
            modif = '';
        end
        titleString = sprintf(pattern, table.Name, modif, nr, nc);
        
        % display new title
        set(obj.Handles.Figure, 'Name', titleString);
    end
     
end % end methods


%% Edition of cells
methods
    function onCellEdited(obj, varargin)
        disp('edited a cell');
    end

    function onCellSelected(obj, gcbo, eventdata)  %#ok<INUSL>
        obj.SelectedIndices = eventdata.Indices;
    end

end


%% Figure management
methods
    function close(obj, varargin)
        delete(obj.Handles.Figure);
    end
    
end


end % end classdef


