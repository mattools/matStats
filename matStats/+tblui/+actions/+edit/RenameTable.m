classdef RenameTable < tblui.TableGuiAction
%RENAMETABLE Changes the name of the current table
%
%   Class RenameTable
%
%   Example
%   RenameTable
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
    function obj = RenameTable(viewer)
    % Constructor for RenameTableAction class
        obj = obj@tblui.TableGuiAction(viewer, 'renameTable');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        
        table = obj.Viewer.Doc.Table;

        answer = inputdlg({'Enter the new table name:'}, ...
            'Change Table Name', ...
            1, ...
            {table.Name});
        
        if isempty(answer)
            return;
        end

        % get new name
        newName = answer{1};
        
        % setup new name
        table.Name = newName;
        updateTitle(obj.Viewer);
    end
end % end methods

end % end classdef

