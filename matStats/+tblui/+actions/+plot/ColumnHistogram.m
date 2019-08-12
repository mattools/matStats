classdef ColumnHistogram < tblui.TableGuiAction
%COLUMNHISTOGRAMACTION  One-line description here, please.
%
%   Class ColumnHistogram
%
%   Example
%   ColumnHistogram
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
    function obj = ColumnHistogram(viewer)
    % Constructor for ColumnHistogram class
        obj = obj@tblui.TableGuiAction(viewer, 'columnHistogram');
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
            'selectionmode', 'single');
        
        if ~ok || isempty(sel)
            return;
        end
        
        createPlotFigure(obj.Viewer.Gui);
        
        histogram(table(:,sel));
    end
    
end % end methods

end % end classdef

