classdef SelectRows < tblui.TableGuiAction
%SELECTROWS Select several rows and create new table
%
%   Class SelectRowsAction
%
%   Example
%   SelectRowsAction
%
%   See also
%     tblui.TableGuiAction
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
    function obj = SelectRows(viewer)
    % Constructor for SelectRowsAction class
        obj = obj@tblui.TableGuiAction(viewer, 'selectRows');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        
        table = obj.Viewer.Doc.Table;
        gui = obj.Viewer.Gui;
        
        [sel, ok] = listdlg('ListString', table.RowNames, ...
            'Name', 'Select Rows', ...
            'PromptString', 'Select the rows:', ...
            'ListSize', gui.DlgListSize, ...
            'selectionmode', 'multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        tab2 = table(sel, :);
        createTableViewer(gui, tab2);
        
    end
end % end methods

end % end classdef

