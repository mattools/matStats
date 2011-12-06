function varargout = show(this)
%SHOW Display the content of the table in a new figure
%
%   show(TABLE);
%   Displays the content of the data table TABLE in a new figure, using a
%   'uitable' widget.
%
%   hf = show(TABLE);
%   Returns a handle to the created figure. 
%
%   [hf ht] = show(TABLE);
%   Also returns a handle to the uitable object.
%
%
%   Example
%     tab = Table(rand(5, 3), 'colNames', {'v1', 'var2', 'other'});
%     h = show(tab);
%     close(h);
%
%
%   See also
%     display, uitable
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract table infos
nr = size(this.data, 1);
nc = size(this.data, 2);

% create figure name
figName = sprintf('%s (%d-by-%d Data Table)', this.name, nr, nc);

% Create parent figure
f = figure(...
    'Name', figName, ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'HandleVisibility', 'Callback');

% add a table
hasLevels = sum(~cellfun(@isnumeric, this.levels)) > 0;
if ~hasLevels
    % create a numeric data table
    data2 = this.data;
    
else
    % if data table has levels, need to convert data array
    data2 = num2cell(this.data);
    indLevels = find(~cellfun(@isnumeric, this.levels));
    for i = indLevels
        data2(:,i) = this.levels{i}(this.data(:, i));
    end
    
end

ht = uitable(f, ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'Data', data2,...
    'ColumnName', this.colNames,...
    'RowName', this.rowNames);

% return handle to table if requested
if nargout > 0
    if nargout == 1
        varargout = {f};
    else
        varargout = {f, ht};
    end
end
