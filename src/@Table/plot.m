function varargout = plot(this, varargin)
%PLOT Plot the content of a column
%
%   Syntax
%   plot(TAB, COL)
%   plot(TAB, COLX, COL)
%
%   Description
%   Plot the content of the column specified by COL. COL can be either an
%   index, or a column name.
%
%   Example
%   plot
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

% works for plot(Y)
if ~isempty(varargin)
    indY = columnIndex(this, varargin{1});
    varargin(1) = [];
else
    indY = 1:size(this.data, 2);
end
   
% Choose between plot(Y) or plot(X, Y)
indX = [];
if ~isempty(varargin)
    var1 = varargin{1};
    if isColumnName(this, var1)
        indX = indY;
    	indY = columnIndex(this, var1);
        varargin(1) = [];
    end
    
end


%% Plot data

if isempty(indX)
    % plot(Y)
    h = plot(ax, this.data(:, indY), varargin{:});
else
    % plot(X, Y)
    h = plot(ax, this.data(:, indX), this.data(:, indY), varargin{:});
end

% setup x-axis limits
if isempty(indX)
    set(gca, 'xlim', [1 length(this.rowNames)]);
else
    x = this.data(:, indX);
    set(gca, 'xlim', [min(x) max(x)]);
end


%% Graph decoration

% title is the name of the table
if ~isempty(this.name)
    title(this.name, 'Interpreter', 'none');
end

% legend is the column name
legend(this.colNames{indY});


%% Format output
if nargout > 0
    varargout = {h};
end
