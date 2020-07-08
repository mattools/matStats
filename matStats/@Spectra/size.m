function varargout = size(obj, varargin)
% Size of a spectrum list.
%
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-04-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

varargout = cell(1, max(nargout, 1));
[varargout{:}] = size(obj.Data, varargin{:});    
