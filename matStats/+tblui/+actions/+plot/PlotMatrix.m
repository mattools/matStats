classdef PlotMatrix < tblui.TableGuiAction
% Plot table matrix
%
%   Class PlotMatrix
%
%   Example
%   PlotMatrix
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
    function obj = PlotMatrix(viewer)
    % Constructor for PlotMatrix class
        obj = obj@tblui.TableGuiAction(viewer, 'matrixPlot');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)

        % check viewer has a doc
        if isempty(obj.Viewer.Doc)
            return;
        end
        
        % get table and gui
        table = obj.Viewer.Doc.Table;
        gui = obj.Viewer.Gui;
        
        % choose variables
        [sel, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Select Variables', ...
            'PromptString', 'Select the variables:', ...
            'ListSize', gui.DlgListSize, ...
            'selectionmode', 'multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        % avoid displaying too many variables
        if length(sel) > 12
            button = questdlg(...
                'The number of variables is large, obj could cause\ndisplay lag. Do you want to continue?', ...
                'Display large number of variables?', ...
                'Yes', 'Cancel', 'Cancel');
            if ~strcmp(button, 'Yes')
                return;
            end
        end
        
        % display plot matrix
        figure;
        plotmatrix(table(:, sel));
        
    end
    
end % end methods

end % end classdef

