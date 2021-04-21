function [res, mu, sigma] = zscore(obj, varargin)
% Standardized z-scores of table data.
%
%   ZTAB = zscore(TAB)
%   Returns a centered and scaled version of the variables in Table TAB.
%   The result ZTAB has the same size as input table TAB. For each column,
%   the resulting column is obtained bu substracting the mean, and dividing
%   by the standard deviation. Then, for each column of the result the mean
%   equals 0.0 and the standard deviation equals 1.0 (up to numerical
%   errors).
%
%
%   [Z, MU, SIGMA] = zscore(TAB)
%   Also returns mean(T) in MU and std(T) in SIGMA.
%
%   [...] = zscore(TAB, 1) 
%   Normalizes TAB using std(TAB,1), i.e., by computing the standard
%   deviation using N rather than N-1, where N is the number of rows in
%   TAB. zscore(T,0) is the same as zscore(T).
%
%   Example
%     % Compute zscore of Iris numerical features
%     iris = Table.read('fisherIris.txt');
%     z = zscore(iris(:, 1:4));
%     [mean(z) ; std(z)]
%     ans = 
%                  SepalLength      SepalWidth     PetalLength     PetalWidth
%         mean    -1.4572e-015    -1.7225e-015    -2.0436e-015    -9.844e-017
%          std               1               1               1              1
%
%   See also
%     mean, std, var
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-07-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if hasFactors(obj)
    error('Table:zscore', 'Can not compute zscore for table with factors');
end

% process input arguments
flag = 0;
if nargin > 1
    flag = varargin{1};
end

% compute basic stats
mu = mean(obj);
sigma = std(obj, flag);

% number of 
n = size(obj, 1);

% compute standardised z-score
res = (obj - repmat(mu, n, 1)) ./ repmat(sigma, n, 1);
res.ColNames = obj.ColNames;
