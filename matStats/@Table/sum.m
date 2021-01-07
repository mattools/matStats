function res = sum(obj, varargin)
% Put the sum of each column in a new table.
%
%   RES = sum(TAB)
%   Computes the sum of each column in the table.
%
%   RES = sum(TAB, DIM)
%   Specifies the dimension for computing sum. Default is 1.
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     res = sum(tab(:, 1:4))
%     res = 
%                SepalLength    SepalWidth    PetalLength    PetalWidth
%     sum              876.5         458.6          563.7         179.9
% 
%
%   See also
%     mean, sum
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check validity
if hasFactors(obj)
    error('MatStats:sum:FactorColumn', ...
        'Can not compute sum for table with factors');
end

% compute name for result
newName = '';
if ~isempty(obj.Name)
    newName = ['Sum of ' obj.Name];
end

% parse direction
dim = 1;
if ~isempty(varargin)
    var1 = varargin{1};
    if isnumeric(var1) && isscalar(var1)
       dim = var1;
    else
        error('Can not interpret optional argument');
    end
end

% create result table
if dim == 1
    res = Table.create(sum(obj.Data, 1), ...
        'RowNames', {'sum'}, ...
        'ColNames', obj.ColNames, ...
        'Name', newName);
elseif dim == 2
    res = Table.create(sum(obj.Data, 2), ...
        'RowNames', obj.RowNames, ...
        'ColNames', {'sum'}, ...
        'Name', newName);
end