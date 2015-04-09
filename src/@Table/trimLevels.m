function res = trimLevels(this)
%TRIMLEVELS Recompute level indices to keep only existing values
%
%   TAB2 = trimLevels(TAB);
%   TAB should be a table with 1 column and should be a factor column.
%
%   Example
%     % read input table
%     iris = Table.read('fisherIris.txt');
%     % select observations from only 2 species
%     inds = ismember(iris('Species').data, [2 3]);
%     tab2 = iris(inds, :);
%     % the level indices do not start at 1
%     unique(tab2.data(:,5))
%     ans =
%           2
%           3
%     % create new table with level indices starting at 1
%     tab3 = trimLevels(tab2);
%     unique(tab3.data(:,5))
%     ans =
%           1
%           2
%
%   See also
%     isFactor, setFactorLevels, setAsFactor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-07-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% first make a copy of this table
res = Table(this);

% iterate over the factor columns
for i = 1:size(this, 2)
    if ~isFactor(this, i)
        continue;
    end
    
    % extract factor column data
    inds0 = this.data(:, i);
    levels = this.levels{i};
    
    % find unique indices. New indices are given by J
    [uniqueInds, I, J] = unique(inds0); %#ok<ASGLU>

    % store result in the new table
    res.data(:,i) = J;
    res.levels{i} = levels(uniqueInds);
end

