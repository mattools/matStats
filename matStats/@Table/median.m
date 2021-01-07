function res = median(obj, varargin)
% Put the median of each column in a new table.
%
%   RES = median(TAB)
%   Computes the median of each column in the table, and put the result in
%   a new table.
%
%   RES = median(TAB, DIM)
%   Specifies the dimension for computing sum. Default is 1.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     median(iris(:,1:4))
%     ans =
%                   SepalLength    SepalWidth    PetalLength    PetalWidth
%         median            5.8             3           4.35           1.3
%
%   See also
%     mean, std, sum
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% check conditions
if hasFactors(obj)
    error('Can not compute median for table with factors');
end

% parse dimension to process
dim = 1;
if ~isempty(varargin)
    var1 = varargin{1};
    if isnumeric(var1) && isscalar(var1)
       dim = var1;
    else
        error('Can not interpret optional argument');
    end
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Median of ' obj.Name];
end

if dim == 1
    res = Table.create(median(obj.Data, 1), ...
        'Parent', obj, ...
        'RowNames', {'median'}, ...
        'Name', newName);
    
else
    res = Table.create(median(obj.Data, 2), ...
        'Parent', obj, ...
        'ColNames', {'median'}, ...
        'Name', newName);
    
end   