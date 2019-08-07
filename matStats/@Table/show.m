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
% e-mail: david.legland@inra.fr
% Created: 2011-03-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract table infos
nr = size(this.Data, 1);
nc = size(this.Data, 2);

% create figure name
figName = sprintf('%s (%d-by-%d Data Table)', this.Name, nr, nc);

% Create parent figure
f = figure(...
    'Name', figName, ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'HandleVisibility', 'Callback');

% convert numerical data to cell array
data2 = num2cell(this.Data);
    
% if data table has factors, need to convert factor levels
% hasLevels = sum(~cellfun(@isnumeric, this.levels)) > 0;
if hasFactors(this)
    indLevels = find(~cellfun(@isnumeric, this.Levels));
    for i = indLevels
        data2(:,i) = this.Levels{i}(this.Data(:, i));
    end
    
end

data2 = [this.RowNames(:) data2];

% ht = uitable(f, ...
%     'Units', 'normalized', ...
%     'Position', [0 0 1 1], ...
%     'Data', data2,...
%     'ColumnName', this.colNames,...
%     'RowName', this.rowNames);
ht = uitable(f, ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'Data', data2,...
    'ColumnName', [{'Name'} this.ColNames]);

% return handle to table if requested
if nargout > 0
    if nargout == 1
        varargout = {f};
    else
        varargout = {f, ht};
    end
end
