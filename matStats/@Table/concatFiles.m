function varargout = concatFiles(inputFiles, outputFile, varargin)
%CONCATFILES  Concatenate a list of files containing tables into new a file
%
%   concatFiles(INPUT_FILES, OUTPUT_FILE)
%
%   Example
%   % Concatenate a list of files
%   Table.concatFiles({'tab1.txt', 'tab2.txt'}, 'grouped.txt');
%
%   % concatenate all the text files in a directory
%   Table.concatFiles('input/*.txt', 'grouped.txt');
%
%
%   See also
%     Table.read
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-07-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% if input is given as a pattern, compute the list of names
if ischar(inputFiles)
    [path, baseName] = fileparts(inputFiles); %#ok<ASGLU>
    list = dir(inputFiles);
    
    nFiles = length(list);
    inputFiles = cell(1, nFiles);
    for i = 1:nFiles
        inputFiles{i} = fullfile(path, list(i).name);
    end
end

% initialize result with first file
res    = Table.read(inputFiles{1});

% concatenate all params
for i = 2:length(list)
    tab = Table.read(inputFiles{i});
    res = [res ; tab]; %#ok<AGROW>
end

% save result
if nargin > 1
    write(res, outputFile);
end

if nargout > 0
    varargout = {res};
end
