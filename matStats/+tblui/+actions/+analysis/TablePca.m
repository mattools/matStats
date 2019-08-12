classdef TablePca < tblui.TableGuiAction
% Compute principal component analysis of current table
%
%   Class TablePca
%
%   Example
%   TablePca
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
    function obj = TablePca(parent)
    % Constructor for TablePcaAction class
        obj = obj@tblui.TableGuiAction(parent, 'PCA');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        
        if isempty(obj.Viewer.Doc)
            return;
        end
        table = obj.Viewer.Doc.Table;
        
        % open a dioalog to set up PCA options and launch computation
        tblui.pca.PcaDialog(obj.Viewer.Gui, table);
    end
end % end methods

end % end classdef

