function varargout = plot(this, varargin)
%PLOT Plot the content of a column
%
%   Syntax
%   plot(TAB)
%   Plot all columns in table TAB
%
%   plot(TABX, TAB)
%   Plot all columns in table TAB, using TABX as input for x values. TABX
%   must have only one column.
%
%   Description
%   Plot the content of the column specified by COL. COL can be either an
%   index, or a column name.
%
%   Example
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

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
end


%% Plot data

if isempty(tabX)
    % plot(Y)
    h = plot(ax, tabY.data, varargin{:});
    
   % setup x-axis limits
   set(gca, 'xlim', [1 size(tabY.data, 1)]);
    
else
    % plot(X, Y)
    h = plot(ax, xData, tabY.data, varargin{:});
    
    % setup x-axis limits
    set(gca, 'xlim', [min(xData) max(xData)]);
    
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end
end

 
%% Graph decoration

% title is the name of the table
if ~isempty(tabY.name)
    title(tabY.name, 'Interpreter', 'none');
end

if size(tabY.data, 2) > 1
    % legend is the column names
    legend(tabY.colNames);
else
    ylabel(tabY.colNames{1});
end


%% Format output
if nargout > 0
    varargout = {h};
end
