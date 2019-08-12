classdef PlotTableRows < tblui.TableGuiAction
% Plot all rows of the current table
%
%   Class PlotTableRows
%
%   Example
%   PlotTableRows
%
%   See also
%     tblui.plot.PlotTable, tblui.TableGuiAction
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
    function obj = PlotTableRows(viewer)
    % Constructor for PlotTableRows class
        obj = obj@tblui.TableGuiAction(viewer, 'plotTableRows');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        table = obj.Viewer.Doc.Table;
        
        createPlotFigure(obj.Viewer.Gui);
        
        plotRows(table);
        
    end
end % end methods

end % end classdef

