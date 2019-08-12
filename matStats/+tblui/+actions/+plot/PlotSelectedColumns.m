classdef PlotSelectedColumns < tblui.TableGuiAction
% Plot selected columns of the current table
%
%   Class PlotSelectedColumns
%
%   Example
%   PlotSelectedColumns
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
    function obj = PlotSelectedColumns(viewer)
    % Constructor for PlotSelectedColumns class
        obj = obj@tblui.TableGuiAction(viewer, 'plotSelectedColumns');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        table = obj.Viewer.Doc.Table;
        
        [sel, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Plot Histogram', ...
            'PromptString', 'Select the variable:', ...
            'ListSize', obj.Viewer.Gui.DlgListSize, ...
            'selectionmode', 'multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        
        createPlotFigure(obj.Viewer.Gui);
        
        plot(table(:, sel));
        
    end
end % end methods

end % end classdef

