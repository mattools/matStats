classdef ViolinPlot < tblui.TableGuiAction
%VIOLINPLOT Plot distribution using violin-like plot
%
%   Class ViolinPlot
%
%   Example
%   ViolinPlot
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
    function obj = ViolinPlot(viewer)
    % Constructor for BoxplotAction class
        obj = obj@tblui.TableGuiAction(viewer, 'boxplot');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        gui = obj.Viewer.Gui;
        table = obj.Viewer.Doc.Table;

        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Violin Plot', ...
            'PromptString', 'Variables to display:', ...
            'ListSize', gui.DlgListSize, ...
            'SelectionMode', 'Multiple');

        if ~ok || isempty(indVar)
            return;
        end

        createPlotFigure(gui);

        violinPlot(table(:, indVar));

    end
end % end methods

end % end classdef

