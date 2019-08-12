classdef OpenTable < tblui.TableGuiAction
%OPENTABLE Open a new data table stored in a file
%
%   Class OpenTable
%
%   Example
%   OpenTable
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
    function obj = OpenTable(viewer)
    % Constructor for OpenTable class
        obj = obj@tblui.TableGuiAction(viewer, 'openTable');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        disp('Open new table ');
        
        % get handle to parent figure, and current doc
        viewer = obj.Viewer;
        gui = viewer.Gui;
        
        [fileName, pathName] = uigetfile( ...
            {'*.txt;*.csv',     'All Text Files (*.txt, *.csv)'; ...
            '*.txt',            'Text Files (*.txt)'; ...
            '*.csv',            'Coma-Separated Values (*.csv)'; ...
            '*.div',            'DIV Files (*.div)'; ...
            '*.*',              'All Files (*.*)'}, ...
            'Choose a data table file to open:');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end

        % read the table
        tab = Table.read(fullfile(pathName, fileName));
        
        % add image to application, and create new display
        createTableViewer(gui, tab);
    end
end % end methods

end % end classdef

