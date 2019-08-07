function varargout = barweb(values, errors, varargin)
%BARWEB  Bar plot of the table data with error bars ("WEB")
%
%   barweb(VALS, ERR)
%   Simple wrapper to the barweb contribution, that also displays
%   appropriate labels.
%
%   barweb(..., 'legendLocation', LOC)
%   Specifies the location of the legend. See legend for details.
%
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     meanIris = groupStats(iris(:,1:4), iris(:,5), @mean);
%     stdIris = groupStats(iris(:,1:4), iris(:,5), @std);
%     barweb(meanIris', stdIris')
%
%   See also
%     bar, errorbar

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

%% Parse input arguments

% default settings
width = 1;
legendLocation = 'NorthEast';

% eventually extract bar width as first non-char argument
if ~isempty(varargin)
    if isnumeric(varargin{1})
        width = varargin{1};
        varargin(1) = [];
    end
end

% extraction of parameters name-value pairs
while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'barwidth'
            width = varargin{2};
        case 'legendlocation'
            legendLocation = varargin{2};
        otherwise
            error(['Unknown parameter name: ' paramName]);
    end

    varargin(1:2) = [];
end


%% Pre-processing

% check values and error arrays have same size
if any(size(values) ~= size(errors))
    error('values and errors arrays must have same size');
end

change_axis = 0;

% special case of array with one column or one row
if size(values,2) == 1
    values = values';
    errors = errors';
end
if size(values,1) == 1
    values = [values; zeros(1,length(values))];
    errors = [errors; zeros(1,size(values,2))];
%     change_axis = 1;
end

groupNames = values.RowNames;

% number of groups
numGroups = size(values, 1); 

% number of bars in a group
numBars = size(values, 2); 


%% Draw bars and error bars

handles.axis = gca;
holdStatus = ishold;

% First draw the bars, using native Matlab function
handles.bars = bar(values.Data, width); 
hold on;

% draw error bars
groupwidth = min(0.8, numBars/(numBars+1.5));
for i = 1:numBars
    x = (1:numGroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numBars);
    handles.errors(i) = errorbar(x, values.Data(:,i), errors.Data(:,i), 'k', 'linestyle', 'none');
end

if ~isempty(groupNames)
    set(gca, 'xticklabel', groupNames, 'xtick',1:numGroups);
end

xlim([0.5 numGroups-change_axis+0.5]);

handles.legend = legend(values.ColNames, 'Location', legendLocation);

% restore hold state of current figure
if ~holdStatus
    hold off;
end

if nargout > 0
    varargout = {handles};
end