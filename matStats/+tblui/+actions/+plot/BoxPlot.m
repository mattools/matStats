classdef BoxPlot < tblui.TableGuiAction
%Box Plot
%
%   Class BoxPlot
%
%   Example
%   BoxPlot
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
    function obj = BoxPlot(viewer)
    % Constructor for BoxPlot class
        obj = obj@tblui.TableGuiAction(viewer, 'boxplot');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        gui = obj.Viewer.Gui;
        table = obj.Viewer.Doc.Table;

        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'BoxPlot', ...
            'PromptString', 'Variables to display:', ...
            'ListSize', gui.DlgListSize, ...
            'SelectionMode', 'multiple');

        if ~ok || isempty(indVar)
            return;
        end

        createPlotFigure(gui);

        boxplot(table(:, indVar));

    end
end % end methods

end % end classdef

