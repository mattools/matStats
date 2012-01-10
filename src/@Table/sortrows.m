function [res I] = sortrows(this, varargin)
%SORTROWS Sort entries of data table according to row names
%
%   TAB2 = sortrows(TAB)
%   Sorts data table according to row names
%
%   TAB2 = sortrows(TAB)
%   Sorts data table according to entry specified by COLNAME. COLNAME can
%   be either an index or the name of a column.
%
%   Example
%   sortrows
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-01-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% determines row order
if isempty(varargin)
    [dum I] = sortrows(this.rowNames); %#ok<ASGLU>
else
    ind = columnIndex(this, varargin{1});
    [dum I] = sortrows(this.data(:, ind)); %#ok<ASGLU>
end

% transform data
res = Table(this.data(I,:), 'rowNames', this.rowNames(I), 'parent', this);
