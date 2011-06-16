function tab = stats(this, varargin)
%STATS Compute basic descriptive statistics on data table columns
%
%   RES = TAB.stats(STAT_NAMES)
%   RES = stats(TAB, STAT_NAMES)
%   Computes several descriptive statistics on the data table TAB.
%
%   STATS specifies which statistics will be computed. STATS is a cell
%   array containing strings, each string being the name of a statistic:
%   'mean'  mean of the data
%   'var'   variance of the data
%   'std'   standard deviation of the data (normalized by (n-1))
%   'sem'   standard error of the mean, assuming gaussian distribution of data
%   'min'   minimal value of the data
%   'max'   maximal value of the data
%   'median' median value of the data
%   'sum'   the sum of the data
%   'dyn'   the dynamic of the data (max-min)
%   'count' the number of elements which are not 'NaN'
%
%   The result is sored if a table RES, with as many columns as the number
%   of columns of TAB, and as many rows as the number of computed
%   statistics.
%
%   If data table contains NaN values, they are treated as missing values.
%
%   RES = stats(TABLE)
%   Compute only basic statistics: 'mean', 'std', 'median', 'sem'.
%
%   Example
%   stats
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-04-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% process input data

% number of vars
nCols   = size(this.data, 2);

% default statistics to compute
statNames = {'min', 'median', 'mean', 'max', 'std'};

% if statistic list is provided, use it
if ~isempty(varargin)
    var = varargin{1};
    if iscell(var)
        statNames = var;
    elseif ischar(var)
        statNames = {var};
    else
        error('Second argument must be a cell array of string or a string');
    end
end

% number of stats
nStats  = length(statNames);


%% compute statistics 

% allocate memory for result
res = zeros(nStats, nCols);
res(:) = NaN;

% process each column in data table
for c = 1:nCols
    
    if ~isempty(this.levels{c})
        continue;
    end
    
    % extract current column
    col = this.data(:, c);
    
    % remove NaN values
    col = col(~isnan(col));
    
    % compute each statistic on the current column
    for s = 1:nStats
        
        statName = statNames{s};
        if strcmp(statName, 'mean')
            % compute mean
            res(s, c) = mean(col);
            
        elseif strcmp(statName, 'var')
            % compute variance
            res(s, c) = var(col);
            
        elseif strcmp(statName, 'std')
            % compute standard deviation
            res(s, c) = std(col);
        elseif strcmp(statName, 'sem')
            % compute standard error of the mean
            res(s, c) = std(col) / sqrt(length(col));
            
        elseif strcmp(statName, 'min')
            % minimal value
            res(s, c) = min(col);
            
        elseif strcmp(statName, 'max')
            % maximal value
            res(s, c) = max(col);
            
        elseif strcmp(statName, 'median')
            % median value
            res(s, c) = median(col);
            
        elseif strcmp(statName, 'sum')
            % sum of the values
            res(s, c) = sum(col);
            
        elseif strcmp(statName, 'dyn')
            % dynamic (difference of extreme values)
            res(s, c) = max(col) - min(col);
            
        elseif strcmp(statName, 'count')
            % number of elements
            res(s, c) = length(col);
            
        else
            error('Unknown statistic name: %s', statName);
        end
    end
end


%% format result as data table

% create the table
tab = Table(res, 'colNames', this.colNames, 'rowNames', statNames');

% compute name of the table
if ~isempty(this.name)
    tab.name = [this.name '-Stats'];
else
    tab.name = 'stats';
end
