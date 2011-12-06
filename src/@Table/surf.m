function varargout = surf(this, varargin)
%SURF Surfacic representation of the data stored in a Table
%
%   output = surf(input)
%
%   Example
%   surf
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

h = surf(this.data, varargin{:});

if isempty(get(get(gca, 'title'), 'string'))
    title(this.name);
end

if nargout > 0
    varargout = {h};
end
