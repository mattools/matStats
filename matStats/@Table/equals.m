function res = equals(this, that)
%EQUALS Checks if two Table objects are the same
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
if ~isa(this, 'Table')
    return;
end

if ~isa(that, 'Table')
    return;
end

% check data
if sum(size(this.Data) ~= size(that.Data)) > 0
    return;
end
if sum(this.Data(:) ~= that.Data(:)) > 0
    return;
end

% check row and column names
if sum(~strcmp(this.ColNames, that.ColNames)) > 0
    return;
end
if sum(~strcmp(this.RowNames, that.RowNames)) > 0
    return;
end

% check levels
if length(this.Levels) ~= length(that.Levels)
    return;
end
for i = 1:length(this.Levels)
    lev1 = this.Levels{i};
    lev2 = that.Levels{i};
    if isempty(lev1) && isempty(lev2)
        continue;
    end
    if sum(~strcmp(lev1, lev2)) > 0
        return;
    end
end

% if everything is ok, return true
res = true;
