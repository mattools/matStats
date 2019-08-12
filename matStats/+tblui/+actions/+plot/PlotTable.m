classdef PlotTable < tblui.TableGuiAction
% Plot all columns of the current table
%
%   Class PlotTable
%
%   Example
%   PlotTable
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
    function obj = PlotTable(parent)
    % Constructor for PlotTable class
        obj = obj@tblui.TableGuiAction(parent, 'plotTable');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        table = obj.Viewer.Doc.Table;
        
        createPlotFigure(obj.Viewer.Gui);
        
        plot(table);
        
    end
end % end methods

end % end classdef

