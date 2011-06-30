function display(this)
%DISPLAY Display the content of a data table
%
%   output = display(input)
%
%   Example
%   display
%
%   See also
%   Table/disp
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% eventually add space
if strcmp(get(0, 'FormatSpacing'), 'loose')
    fprintf('\n'); 
end

% get name to display
objectname = inputname(1);
if isempty(objectname)
   objectname = 'ans';
end

% display object name
fprintf('%s = \n', objectname);

% display object content
disp(this);
