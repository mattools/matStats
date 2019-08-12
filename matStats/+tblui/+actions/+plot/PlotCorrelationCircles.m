classdef PlotCorrelationCircles < tblui.TableGuiAction
% Plot correlation circles
%
%   Class PlotCorrelationCircles
%
%   Example
%   PlotCorrelationCircles
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
    function obj = PlotCorrelationCircles(viewer)
    % Constructor for PlotCorrelationCircles class
        obj = obj@tblui.TableGuiAction(viewer, 'plotCorrelationCircles');
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
        if length(sel) > 25
            button = questdlg(...
                'The number of variables is large, obj could cause\ndisplay lag. Do you want to continue?', ...
                'Display large number of variables?', ...
                'Yes', 'Cancel', 'Cancel');
            if ~strcmp(button, 'Yes')
                return;
            end
        end
        
        % display correlation circles
        figure;
        correlationCircles(table(:, sel));
        
    end
    
end % end methods

end % end classdef

