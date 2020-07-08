function varargout = plot(varargin)
% Display the list of spectra.
%
%   output = plot(input)
%
%   Example
%   plot
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-07-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

%% Parse input arguments

% determines whether an axis handle is given as argument
[ax, varargin] = parseAxisHandle(varargin{:});

% assumes first input argument is the current table
obj = varargin{1};
varargin(1) = [];

% % default tables for plotting
% tabX = [];
% tabY = obj;
% 
% % if two inputs are specified, setup the tabX variable
% if ~isempty(varargin)
%     if isa(varargin{1}, 'SpectrumList')
%         tabX = obj;
%         tabY = varargin{1};
%         varargin(1) = [];
%     end
% end

% default xData values
xAxisLabel = '';

% compute xdata, either from ydata, or from first input argument
xData = obj.XValues;

% if plot into an empty axis, make some additional setups. Otherwise, leave
% as is.
decoratePlot = isempty(get(ax, 'Children'));


%% Parse additional input arguments

% display legend only for small number of rows
showLegend = size(obj, 1) < 20;
ind = find(strcmpi(varargin(1:2:end), 'showLegend'));
if ~isempty(ind)
    showLegend = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end

% display legend in top-right corner
legendLocation = 'NorthEast';
ind = find(strcmpi(varargin(1:2:end), 'legendLocation'));
if ~isempty(ind)
    legendLocation = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end


%% Plot data

hold on;
if isempty(xData)
    % plotRows(Y)
    h = plot(ax, obj.Data', varargin{:});
    
else
    % plotRows(X, Y)
    h = plot(ax, xData, obj.Data', varargin{:});
    xlim(xData([1 end]));
    
    if ~isempty(xAxisLabel)
        xlabel(xAxisLabel);
    end
end


%% Decorate plot

if decoratePlot
    % axis labels
    if ~isempty(obj.AxisNames)
        if ~isempty(obj.AxisNames{2})
            xlabel(obj.AxisNames{2});
        end
    end
    
    % use the 'name' property as title
    if ~isempty(obj.Name)
        title(obj.Name, 'Interpreter', 'none');
    end
    
    % display a legend
    if showLegend
        legend(obj.RowNames, 'Location', legendLocation);
    end
end

%% Format output
if nargout > 0
    varargout = {h};
end
