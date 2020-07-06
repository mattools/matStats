function varargout = groupStats(obj, group, stats, varargin)
% Compute basic statistics for each level of a group.
%
%   RES = groupStats(TAB, FACT)
%   TAB is a obj table or a obj array, FACT is either a numeric
%   vector, a char array, or a obj table with one column.
%   At least one of TAB and FACT must be a Table object.
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
%     aggregate, groupfun
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
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

% extract group infos
[groupIndices, levels, label] = parseGroupInfos(group);
nLevels = length(levels);

% memory allocation
newData = zeros(nLevels, size(obj, 2));

% if obj is a Table object, convert it to simple array
this = [];
if isa(obj, 'Table')
    this = obj;
    obj = obj.Data;
end

varargout = cell(1, nStats);
for s = 1:nStats
    % extract operation to apply
    op = stats{s};
    
    % apply operation on each column
    for i = 1:nLevels
        inds = groupIndices == i;
        for j = 1:size(obj, 2)
            newData(i, j) = feval(op, obj(inds, j));
        end
    end
    
    % extract names of rows, or create them if necessary
    rowNames = strcat([label{1} '='], levels);
        
    % create result objTable
    if isempty(this)
        varargout{s} = Table.create(newData, ...
            'RowNames', rowNames);
    else
        varargout{s} = Table.create(newData, ...
            'Parent', this, ...
            'RowNames', rowNames);
    end
end
