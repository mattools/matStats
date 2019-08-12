classdef PlotColumnsByGroup < tblui.TableGuiAction
% Plot columns by group
%
%   Class PlotColumnsByGroup
%
%   Example
%   PlotColumnsByGroup
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
    function obj = PlotColumnsByGroup(viewer)
    % Constructor for PlotColumnsByGroup class
        obj = obj@tblui.TableGuiAction(viewer, 'scatterPlot');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        gui = obj.Viewer.Gui;
        table = obj.Viewer.Doc.Table;

        [selx, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Scatter Plot', ...
            'PromptString', 'Variable for x-axis:', ...
            'ListSize', gui.DlgListSize, ...
            'SelectionMode', 'Single');

        if ~ok || isempty(selx)
            return;
        end

        [sely, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Scatter Plot', ...
            'PromptString', 'Variable for y-axis:', ...
            'ListSize', gui.DlgListSize, ...
            'SelectionMode', 'Single');

        if ~ok || isempty(sely)
            return;
        end


        createPlotFigure(gui);

        scatter(table, selx, sely);

    end
end % end methods

end % end classdef

