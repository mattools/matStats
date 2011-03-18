function varargout = show(this)
%SHOW Display the content of the table in a new figure
%
%   show(TABLE);
%   TABLE.show();
%   Displays the content of the data table TABLE in a new uitable graphical
%   display.
%
%   Example
%   show
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract table infos
nr = size(this.data, 1);
nc = size(this.data, 2);

% Create parent figure
figName = sprintf('%s (%d-by-%d Data Table)', this.name, nr, nc);
f = figure(...
    'Name', figName, 'NumberTitle', 'off', ...
    'MenuBar', 'none');

% add a table
ht = uitable(f, ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'Data', this.data,... 
    'ColumnName', this.colNames,...
    'RowName', this.rowNames);

% return handle to table if requested
if nargout > 0
    varargout = {ht};
end
