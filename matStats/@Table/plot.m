function varargout = plot(varargin)
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
%     plotRows
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

% extract calling table
this = varargin{1};
varargin(1) = [];

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
xTickLabels = {};

if ~isempty(tabX)
    if isa(tabX, 'Table')
        xData = tabX.Data(:, 1);
        
        xAxisLabel = tabX.ColNames{1};
        if isFactor(tabX, 1)
            xTickLabels = tabX.Levels{1};
        end
    else
        xData = tabX;
    end
end


%% Plot data

if isempty(tabX)
    % plot(Y)
    h = plot(ax, tabY.Data, varargin{:});
    
%     % setup x-axis limits
%     set(gca, 'xlim', [1 size(tabY.data, 1)]);
    
else
    % plot(X, Y)
    h = plot(ax, xData, tabY.Data, varargin{:});
    
%     % setup x-axis limits
%     set(gca, 'xlim', [min(xData) max(xData)]);
    
    % Annotate X axis
    if ~isempty(xTickLabels)
        set(ax, 'XTick', 1:length(xTickLabels));
        set(ax, 'XTickLabel', xTickLabels);
        set(ax, 'XLim', [0 length(xTickLabels)]+.5);
    end
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end

end

 
%% Graph decoration

% title is the name of the table
if ~isempty(tabY.Name)
    title(tabY.Name, 'Interpreter', 'none');
end

if min(size(tabY.Data)) > 1
    % When several curves are drawn, display a legend
    legend(tabY.ColNames);
else
    % otherwise, use only the first column or row as ylabel
    if size(tabY, 2) == 1
        label = tabY.ColNames{1};
    else
        label = tabY.RowNames{1};
    end
    ylabel(label);
end


%% Format output
if nargout > 0
    varargout = {h};
end
