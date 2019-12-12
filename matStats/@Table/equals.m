function res = equals(obj1, obj2)
% Checks if two Table objects are the same.
%
%   RES = equals(TAB1, TAB2)
%   Compares the two data table objects, and returns FALSE if they differ.
%   This method can be used by testing methods for comparing tables with
%   expected results.
%
%   Two tables are considered equal if they have:
%   * same data
%   * same column names
%   * same row names
%   * same factor levels 
%
%
%   Example
%
%
%   See also
%       eq
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% default result is false
res = false;

% check class
if ~isa(obj1, 'Table')
    return;
end

if ~isa(obj2, 'Table')
    return;
end

% check data
if sum(size(obj1.Data) ~= size(obj2.Data)) > 0
    return;
end
if sum(obj1.Data(:) ~= obj2.Data(:)) > 0
    return;
end

% check row and column names
if sum(~strcmp(obj1.ColNames, obj2.ColNames)) > 0
    return;
end
if sum(~strcmp(obj1.RowNames, obj2.RowNames)) > 0
    return;
end

% check levels
if length(obj1.Levels) ~= length(obj2.Levels)
    return;
end
for i = 1:length(obj1.Levels)
    lev1 = obj1.Levels{i};
    lev2 = obj2.Levels{i};
    if isempty(lev1) && isempty(lev2)
        continue;
    end
    if sum(~strcmp(lev1, lev2)) > 0
        return;
    end
end

% if everything is ok, return true
res = true;
