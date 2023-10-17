function res = convertCharArray(names, varargin)
% Create a factor table by parsing a character array.
%
%   FACT = Table.convertCharArray(NAMES)
%   FACT = Table.convertCharArray(NAMES, COLNAME)
%   FACT = Table.convertCharArray(..., PNAME, PVALUE)
%
%   Optional arguments:
%   'substring' (1-by-2 numeric array): returns the part of each string
%       from the start index up to and up to the end index.
%   'name' (char array): the name of the column corresponding to the data
%       (replace COLNAME if specified)
%
%
%   Example
%     data = load('fisheriris');
%     species = Table.convertCharArray(data.species, 'Species');
%     summary(species)
%     
%             Species
%      setosa:     50
%      versicolor: 50
%      virginica:  50
%
%   See also
%     read
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Parse input arguments

% default column name
colName = 'NoName';
if mod(length(varargin), 2) > 0 && ischar(varargin{1})
    colName = varargin{1};
    varargin(1) = [];
end

% parse optional inputs
parser = inputParser;
parser.addParameter('substring', [], @isnumeric);
parser.addParameter('name', colName, @ischar);
parser.parse(varargin{:});

substring = parser.Results.substring;
colName = parser.Results.name;


%% Processing

% convert to char array
names = strjust(char(names), 'left');
    
% optional substring operation
if ~isempty(substring)
    names = names(:, substring(1):substring(2));
end

% keep unique level instances
[levels, m, indices] = unique(names, 'rows'); %#ok<ASGLU>
levels = strtrim(cellstr(levels)');

% create result table
res = Table.create(indices, ...
    'colNames', {colName}, ...
    'levels', {levels});
