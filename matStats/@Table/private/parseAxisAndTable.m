function [ax, this, varargin] = parseAxisAndTable(varargin)
%PARSEAXISANDTABLE Parse handle to axis and to the first table object
%
%   [AX VARARGIN] = parseAxisAndTable(...)
%   If first input argument is an axis handle, return it in AX. Otherwise,
%   return an handle tio th current axis.
%   The rest of the arguments are returned in VARARGIN.
%
%   Example
%   parseAxisAndTable
%
%   See also
%     parseAxisHandle
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

warning('function not in version control...');

% determines whether an axis handle is given as argument
if ~isempty(varargin) && ishandle(varargin{1})
    ax = varargin{1};
    varargin(1) = [];
else
    ax = gca;
end

% extract the first instance of table object
ind = 0;
for i = 1:length(varargin)
    if isa(varargin{1}, 'Table')
        ind = i;
        break;
    end
end
if ind == 0
    error('Could not find index of Table object in argument list');
end
this = varargin{ind};
varargin(ind) = [];
