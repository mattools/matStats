classdef SelectColumns < tblui.TableGuiAction
%SELECTCOLUMNS Select several columns and create new table
%
%   Class SelectColumns
%
%   Example
%   SelectColumns
%
%   See also
%     tblui.TableGui
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SelectColumns(viewer)
    % Constructor for SelectColumnsAction class
        obj = obj@tblui.TableGuiAction(viewer, 'selectColumns');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        
        table = obj.Viewer.Doc.Table;
        gui = obj.Viewer.Gui;
        
        [sel, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Select Columns', ...
            'PromptString', 'Select the columns:', ...
            'ListSize', gui.DlgListSize, ...
            'selectionmode', 'multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        tab2 = table(:, sel);
        createTableViewer(gui, tab2);
        
    end
end % end methods

end % end classdef

