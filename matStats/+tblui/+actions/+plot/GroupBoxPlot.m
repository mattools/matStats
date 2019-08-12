classdef GroupBoxPlot < tblui.TableGuiAction
% GROUPBOXPLOTACTION
%
%   Class GroupBoxPlot
%
%   Example
%   GroupBoxPlot
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
    function obj = GroupBoxPlot(viewer)
    % Constructor for GroupBoxPlot class
        obj = obj@tblui.TableGuiAction(viewer, 'groupBoxplot');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        gui = obj.Viewer.Gui;
        table = obj.Viewer.Doc.Table;

        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'BoxPlot', ...
            'PromptString', 'Variable to display:', ...
            'ListSize', gui.DlgListSize, ...
            'SelectionMode', 'Single');

        if ~ok || isempty(indVar)
            return;
        end

        [indGroup, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'BoxPlot', ...
            'PromptString', 'Grouping variable:', ...
            'ListSize', gui.DlgListSize, ...
            'SelectionMode', 'Single');

        if ~ok || isempty(indGroup)
            return;
        end

        createPlotFigure(gui);

        boxplot(table(:, indVar), table(:, indGroup));

    end
end % end methods

end % end classdef

