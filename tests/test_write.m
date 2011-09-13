function test_suite = test_write(varargin) %#ok<STOUT>
%TEST_WRITE  Test case for the file write
%
%   Test case for the file write

%   Example
%   test_write
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

initTestSuite;

function test_file1 %#ok<*DEFNU>
% Test writing of a file with 2 columns and 6rows

% read test file
tab = Table.read(fullfile('files', 'file1.txt'));

% save test file
fileName = 'test.txt';
if exist(fileName, 'file')
    delete(fileName);
end
write(tab, fileName);

% re-read test file
tab2 = Table.read(fileName);

% check both are the same
assertTrue(equals(tab, tab2));

% clean up
delete(fileName);


function test_fileWithText

tab = Table.read(fullfile('files', 'fileWithText.txt'));

% save test file
fileName = 'test.txt';
if exist(fileName, 'file')
    delete(fileName);
end
write(tab, fileName);

% re-read test file
tab2 = Table.read(fileName);

% check both are the same
assertTrue(equals(tab, tab2));

% clean up
delete(fileName);
