function res = crossTable(obj, obj2)
% Cross-Tabulation of two Tables.
%
%   XTAB = crossTable(TAB1, TAB2)
%
%   Example
%     % Simple example from 'crosstab' doc
%     tab1 = Table([1 1 2 3 1]', {'x'});
%     tab2 = Table([1 2 5 3 1]', {'y'});
%     xtab = crossTable(tab1, tab2)
%     ans = 
%              1    2    3    5
%         1    2    1    0    0
%         2    0    0    0    1
%         3    0    0    1    0
% 
%     % Compare result of k-means on Iris with original classification 
%     iris = Table.read('fisherIris.txt');
%     resKMeans = kmeans(iris(:,1:4), 3);
%     crossTable(iris('Species'), resKMeans)
%     ans = 
%                        1     2     3
%     Setosa            50     0     0
%     Versicolor         0     2    48
%     Virginica          0    36    14
%     % (results may differ depending on random number initialization)
%
%   See also
%     crosstab, grp2idx
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-11-21,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - Cepia Software Platform.

% dimensions check
nr = size(obj, 1);
if size(obj2, 1) ~= nr
    error('Both inputs must have same numer of rows');
end
if size(obj, 2) ~= 1 || size(obj2, 2) ~= 1
    error('Input must have only one column');
end

% convert grouping variables to indices
[inds1, levels1] = parseGroupInfos(obj.Data);
[inds2, levels2] = parseGroupInfos(obj2.Data);

n1 = length(levels1);
n2 = length(levels2);

if ~isempty(obj.Levels{1})
    levels1 = obj.Levels{1};
end
if ~isempty(obj2.Levels{1})
    levels1 = obj2.Levels{1};
end

% compute cross-table
resData = zeros(n1, n2);
for i1 = 1:n1
    for i2 = 1:n2
        count = sum(inds1 == i1 & inds2 == i2);
        resData(i1, i2) = count;
    end
end

res = Table.create(resData, levels2, levels1);
