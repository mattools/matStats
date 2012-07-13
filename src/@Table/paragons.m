function [res inds] = paragons(this, group)
%PARAGONS Find paragon for each level of a group
%
%   PARS = paragons(TAB, G)
%   For each group in G, compute the centroid of the numerical values in
%   TAB, and find the row in TAB which is the closest to the centroid.
%
%   Example
%   % Compute paragons of fisher's iris
%     iris = Table.read('fisherIris.txt');
%     [pars inds] = paragons(iris(:,1:4), iris('Species'));
%     figure; hold on;
%     scatterGroup(iris(:,1), iris(:,2), iris('Species'));
%     for i = 1:3
%         drawPoint(pars(i,1).data, pars(i,2).data, 'ko')
%     end
%
%   See also
%   groupStats
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

[indices levelNames label] = parseGroupInfos(group);

nGroups = length(levelNames);

res = Table(zeros([nGroups size(this, 2)]), 'colNames', this.colNames);
inds = zeros(nGroups, 1);

for i = 1:nGroups
    % data for current level
    tabi = this.data(indices == i, :);
    
    inds_i = find(indices == i);
    centre = mean(tabi);
    
    % find which individual of current group is the closest to the group
    % centroid
    [dum ind] = min(sum(bsxfun(@minus, tabi, centre).^2, 2)); %#ok<ASGLU>
    
    % compute index relative to initial array
    inds(i) = inds_i(ind);

    res.data(i,:) = this.data(inds(i), :);
    res.rowNames{i} = [label{1} '=' levelNames{i}];
end

