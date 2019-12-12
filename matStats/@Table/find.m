function varargout = find(obj, varargin)
% Find non zero elements in the table.
%
%   INDS = find(TAB)
%   
%   Example
%     % find index of value in the table
%     tab = Table(magic(4));
%     ind = find(tab == 12)
%     ind =
%         15
%
%     % get row and column indices
%     [r c] = find(tab == 12)
%     r =
%         3
%     c =
%         4
%
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nv = max(nargout, 1);
varargout = cell(1, nv);

[varargout{:}] = find(obj.Data, varargin{:});
