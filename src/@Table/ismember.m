function res = ismember(this, values)
%ISMEMBER  Override the ismember function
%
%   RES = ismember(TAB, VALS)
%   Returns a data table with same number of rows and columns as the input
%   table, containing boolean depending on whether the corresponding data
%   are member of the specified value(s).
%
%   Example
%     tab = Table(magic(3));
%     ismember(tab, [1 2 3])
%     ans = 
%              1    2    3
%         1    0    1    0
%         2    1    0    0
%         3    0    0    1

%
%   See also
%     find
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

dat = ismember(this.data, values);

res = Table(dat, 'parent', this);
