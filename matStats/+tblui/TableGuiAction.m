classdef TableGuiAction < handle
%TABLEGUIACTION  One-line description here, please.
%
%   Class TableGuiAction
%
%   Example
%   TableGuiAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % the parent GUI, an instance of TableViewer
    Viewer;
    
    % the name of this action, that should be unique for all actions
    Name;
    
end % end properties


%% Constructor
methods
    function this = TableGuiAction(viewer, name)
    % Constructor for TableGuiAction class
        this.Viewer = viewer;
        this.Name = name;
    end

end % end constructors


%% Methods
methods (Abstract)
    % Performs the action defined by this Action object
    actionPerformed(obj, src, event)
end

methods
    function b = isActivable(obj) %#ok<MANU>
        % Returns true is current action is activable. Default is true.
        b = true;
    end
end % end methods

end % end classdef

