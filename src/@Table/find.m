function varargout = find(this, varargin)
%FIND  Find non zero elements in the table
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
%         15
%     c =
%         15
%
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nv = max(nargout, 1);
varargout = cell(1, nv);

[varargout{:}] = find(this.data, varargin{:});
