function ind = end(this, k, n)
%END  Determine last index when accessing a table
%
%   output = end(input)
%
%   Example
%   end
%
%   See Also
%     subsref, subsasgn
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


if n==1
    ind = numel(this.Data);
elseif n==2
    ind = size(this.Data, k);
else
    error('Table:end', 'not enough dimension in Table object');
end
