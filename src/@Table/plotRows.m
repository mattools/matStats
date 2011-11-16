function varargout = plotRows(this, varargin)
%PLOTROWS Plot all the rows of the data table
%
%   plotRows(TAB)
%
%   Example
%   plotRows
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% determines whether an axis handle is given as argument
ax = gca;
if ~isempty(varargin)
    if ishandle(varargin{1})
        ax = varargin{1};
        varargin(1) = [];
    end
end

% default tables for plotting
tabX = [];
tabY = this;

% if two inputs are specified, setup the tabX variable
if ~isempty(varargin)
    if isa(varargin{1}, 'Table')
        tabX = this;
        tabY = varargin{1};
        varargin(1) = [];
    end
end


xData = [];
xAxisLabel = '';

if ~isempty(tabX)
    if isa(tabX, 'Table')
        xData = tabX.data(:, 1);
        xAxisLabel = tabX.colNames{1};
    else
        xData = tabX;
    end
    
else
    % try to parse column names of input table
    vals = str2num(char(tabY.colNames')); %#ok<ST2NM>
    if length(vals) == size(tabY, 2)
        xData = vals;
    end
end


%% Plot data

if isempty(xData)
    % plot(Y)
    h = plot(ax, tabY.data', varargin{:});
    
else
    % plot(X, Y)
    h = plot(ax, xData, tabY.data', varargin{:});
    
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end
end


% title is the name of the table
if ~isempty(tabY.name)
    title(tabY.name, 'Interpreter', 'none');
end

if min(size(tabY.data)) > 1
    % When several curves are drawn, display a legend
    legend(tabY.rowNames);
else
    % otherwise, use only the first column or row as ylabel
    ylabel(tabY.rowNames{1});
end


%% Format output
if nargout > 0
    varargout = {h};
end
