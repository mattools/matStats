function res = reshape(obj, newDim, varargin)
% Reshape a data table.
%
%   RES = reshape(TAB, [M N])
%   RES = reshape(TAB, M, N)
%   returns the M-by-N data table whose elements are taken columnwise from
%   the data table TAB. An error results when TAB does not have M*N
%   elements. 
%
%   Example
%     reshape
%
%   See also
%     size
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-05-24,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% parse new dimension
if isscalar(newDim)
    if nargin < 3
        error('The number of columns needs to be specified');
    end
    newDim = [newDim varargin{1}];
    varargin(1) = [];
end

% check dimension of tables
if prod(newDim) ~= prod(size(obj)) %#ok<PSIZE>
    error('new table must have the same number of elements');
end

% extract row or column names
colNames = {};
rowNames = {};
if ~isempty(varargin) && iscell(varargin{1})
    colNames = varargin{1};
    varargin(1) = [];
end
if ~isempty(varargin) && iscell(varargin{1})
    rowNames = varargin{1};
    varargin(1) = []; %#ok<NASGU>
end

% create result data table
res = Table.create(zeros(newDim));
res.Data(:) = obj.Data(:);

% setup meta data if needed
if ~isempty(colNames)
    res.ColNames = colNames;
end
if ~isempty(rowNames)
    res.RowNames = rowNames;
end
