function res = diff(this, varargin)
%DIFF Derivative approximation by finite differences
%
%   RES = diff(TAB)
%   Computes the finite difference of each column in the input table TAB,
%   and returns a new Table instance with one row less than original.
%
%   Example
%     tab = Table.read('fisherIris.txt');
%     res = diff(tab(:,1:4));
%     size(res)
%     ans =
%         149   4
%
%   See also
%     cumsum, sum, minus
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-10-16,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.


%% Parses input arguments

n = 1;
dim = 1;

if ~isempty(varargin)
    n = varargin{1};
    varargin(1) = [];
end

if ~isempty(varargin)
    dim = varargin{1};
end


%% Check validity

if hasFactors(this)
    error('MatStats:diff:FactorColumn', ...
        'Can not process a table containing factors');
end


%% process input data
newData = diff(this.data, n, dim);


%% format output table
if dim == 1
    rowNames = strcat('(', this.rowNames(2:end), ')-(', this.rowNames(1:end-1), ')');
    res = Table(newData, this.colNames, rowNames);
else
    colNames = strcat('(', this.colNames(2:end)', ')-(', this.colNames(1:end-1)', ')')';
    res = Table(newData, colNames, this.rowNames);
end
