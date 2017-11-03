function [ax varargin] = parseAxisHandle(varargin)
%PARSEAXISHANDLE Parse handle to axis, or return current axis
%
%   [ax varargin] = parseAxisHandle(varargin{:})
%   If first input argument is an axis handle, return it in AX. Otherwise,
%   return an handle to the current axis.
%   The rest of the arguments are returned in VARARGIN.
%
%   Example
%     function myFunction(varargin)
%       [ax varargin] = parseAxisHandle(varargin{:});
%       % ... parse other arguments
%       plot(ax, ...); % plot on specified axis
%
%   See also
%     parseAxisAndTable
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% varargin can not be empty
if isempty(varargin)
    error('can not be called without argument');
end

ax = [];
    
var1 = varargin{1};
if isa(var1, 'Table')
    % first argument can be a Table class if called using syntax T.plot(..)
    % in this case, check if second argument is a scalar axis handle
    if nargin > 1
        var2 = varargin{2};
        if isAxesHandle(var2)
            ax = var2;
            varargin(2) = [];
        end
    end
    
else
    % if first argument is not a table, it can be an axis or something else
    % (x data...)
    if isAxesHandle(var1)
        ax = var1;
        varargin(1) = [];
    end
end

% if no axis was found, return current one
if isempty(ax)
    ax = gca;
end


function b = isAxesHandle(h)

b = isscalar(h) && ishandle(h) && strcmp(get(h, 'type'), 'axes');