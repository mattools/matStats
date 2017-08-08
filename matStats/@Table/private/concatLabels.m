function res = concatLabels(labels, varargin)
%CONCATLABELS Concatenate several labels by adding a separator
%
%   STRING = concatLabels(LABELS)
%   Concatenates several labels stored in a cell array, and return a cell
%   array containing the concatenated string(s)
%
%   Example
%   concatLabels({'geno', 'tissue'})
%     ans =
%        'geno*tissue'
%
%   concatLabels({'Setosa', 'true'; 'Setosa', 'false'; 'Virginica', 'true'; 'Virginica', 'false'})
%     ans =
%         'Setosa*true'
%         'Setosa*false'
%         'Virginica*true'
%         'Virginica*false'
%
%   See also
%      formatLevelLabels
 
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2014-07-25,    using Matlab 8.3.0.532 (R2014a)
% Copyright 2014 INRA - Cepia Software Platform.

nLabels = size(labels, 1);
nCols = size(labels, 2);

res = cell(nLabels, 1);

for iLabel = 1:nLabels
    name = labels{iLabel, 1};
    for iGroup = 2:nCols
        name = [name '*' labels{iLabel, iGroup}]; %#ok<AGROW>
    end
    res{iLabel} = name;
end

