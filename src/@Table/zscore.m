function [res, mu, sigma] = zscore(this, varargin)
%ZSCORE Standardized z-score
%
%   Z = zscore(TAB)
%   Returns a centered a,d scaled version of T, the same size as T.
%   For vector input T, Z is the vector of z-scores (T-mean(T)) ./ std(T).
%   For matrix T, z-scores are computed using the mean and standard
%   deviation along each column of T.
%
%   [Z, MU, SIGMA] = zscore(T)
%   Also returns mean(T) in MU and std(T) in SIGMA.
%
%   [...] = zscore(T, 1) 
%   normalizes T using std(T,1), i.e., by computing the standard deviation
%   using N rather than N-1, where N is the number of rows in T.  
%   zscore(T,0) is the same as zscore(T).
%
%   Example
%     % Compute zscore of Iris numerical variables
%     iris = Table.read('fisherIris.txt');
%     z = zscore(iris(:, 1:4));
%     [mean(z) ; std(z)]
%     ans = 
%                  SepalLength      SepalWidth     PetalLength     PetalWidth
%         mean    -1.4572e-015    -1.7225e-015    -2.0436e-015    -9.844e-017
%          std               1               1               1              1
%
%   See also
%   mean, std
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-07-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% process input arguments
flag = 0;
if nargin > 1
    flag = varargin{1};
end

% compute basic stats
mu = mean(this);
sigma = std(this, flag);

% number of 
n = size(this, 1);

% compute standardiser z-score
res = (this - repmat(mu, n, 1)) ./ repmat(sigma, n, 1);
res.colNames = this.colNames;
