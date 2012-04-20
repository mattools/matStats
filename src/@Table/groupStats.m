function varargout = groupStats(this, group, stats, varargin)
%GROUPSTATS Compute basic statistics for each level of a group
%
%   RES = groupStats(TAB, FACT)
%   TAB is a data table with only one column, FACT is either a numeric
%   vector, a char array, or a data table with one column.
%
%   The function extracts levels of the factor input, and computes a set of
%   descriptive statistics for the input values coresponding to this level.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     groupStats(iris(:, 1:4), iris('Species'))
%     ans =
%                       SepalLength    SepalWidth    PetalLength    PetalWidth
%             Setosa          5.006         3.418          1.464         0.244
%         Versicolor          5.936          2.77           4.26         1.326
%          Virginica          6.588         2.974          5.552         2.026
%
%
%   See also
%   aggregate
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

% if operation is not specified, use 'mean' by default
if nargin < 3
    stats = {@mean};
end

% ensure stats is a cell array
if ~iscell(stats)
    stats = {stats};
end
nStats = length(stats);

% check validity of group
if size(group, 2) > 1
    error('group argument must have only 1 column');
end

[groupIndices levels label] = parseGroupInfos(group);
nLevels = length(levels);

varargout = cell(1, nStats);
for s = 1:nStats
    % extract operation to apply
    op = stats{s};
    
    % apply operation on each column
    data = zeros(nLevels, size(this, 2));
    for i = 1:nLevels
        inds = groupIndices == i;
        for j = 1:size(this, 2);
            data(i, j) = feval(op, this.data(inds, j));
        end
    end
    
    % extract names of rows, or create them if necessary
    %rowNames = strcat([label '='], levels);
    rowNames = levels;
    
    % create result dataTable
    varargout{s} = Table(data, ...
        'parent', this, ...
        'rowNames', rowNames);    
end
