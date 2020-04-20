function [index, dist] = findClosestPoint(obj, coords, varargin)
% Find the index of the row with closest coordinates.
%
%   IND = findClosestPoint(TAB, COORDS)
%   Finds the index of the row whose coordinates are the closest one from
%   the specified coordinates. TAB must contain only numeric features.
%   COORDS must be a row vector with as many columns as the input table.
%   Can be used to identify individual(s) on scatter plots based on
%   features.   
%
%   INDS = findClosestPoint(TAB, COORDS)
%   Also works when COORDS is a N-by-NC array of coordinates. In this case,
%   returns a column vector of N indices.
%
%
%   [IND, DIST] = findClosestPoint(TAB, COORDS)
%   Also returns the corresponding distance, or distances.
%
%
%   Example
%     % identifies a measure based on the scatter plot of two features.
%     tab = Table.read('fisherIris');
%     scatter(tab, 1, 2);
%     tab(findClosestPoint(tab(:, [1 2]), [5 4.2]), :)
%     ans = 
%               SepalLength    SepalWidth    PetalLength    PetalWidth    Species
%     33                5.2           4.1            1.5           0.1     Setosa
%
%   See also
%     scatter, find
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-04-20,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

% allocate memory
np = size(coords, 1);
dist = zeros(np, 1);
index = zeros(np, 1);

% iterate over the query points
for i = 1:np
    % compute squared distance between current point and all point in array
    dists = sum(bsxfun(@minus, obj.Data, coords(i,:)) .^ 2, 2);
    
    % keep index of closest point
    [dist(i), index(i)] = min(dists);
end
