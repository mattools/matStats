classdef OpenDemoTable < tblui.TableGuiAction
%OpenDemoTable  Open a new data table stored in a file
%
%   Class OpenDemoTable
%
%   Example
%   OpenDemoTable
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
    DemoFileName;
end % end properties


%% Constructor
methods
    function obj = OpenDemoTable(viewer, fileName)
    % Constructor for OpenDemoTable class
        obj = obj@tblui.TableGuiAction(viewer, 'OpenDemoTable');
        obj.DemoFileName = fileName;
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        disp('Open demo table ');
        
        % get handle to parent figure, and current doc
        viewer = obj.Viewer;
        gui = viewer.Gui;
        
        % read the demo image
        tab = Table.read(obj.DemoFileName);
        
        % add image to application, and create new display
        createTableViewer(gui, tab);
    end
end % end methods

end % end classdef

