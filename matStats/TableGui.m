function varargout = TableGui(varargin)
%TABLEGUI  Opens a TableViewer for manipulating data tables
%
%   TableGui(TAB)
%   GUI = TableGui(TAB)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     TableGui(iris);
%
%   See also
%     Table
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

import tblui.TableViewer;

% check if image is present, or create one
tab = [];
if ~isempty(varargin)
    tab = varargin{1};
end

% create the application, and a GUI
gui = tblui.TableGui();
viewer = createTableViewer(gui, tab);

if nargout > 0
    varargout = {viewer};
end
