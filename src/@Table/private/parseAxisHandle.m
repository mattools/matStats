function [ax this varargin] = parseAxisHandle(varargin)
%PARSEAXISHANDLE  One-line description here, please.
%
%   output = parseAxisHandle(input)
%
%   Example
%   parseAxisHandle
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% determines whether an axis handle is given as argument
if ~isempty(varargin) &&  ishandle(varargin{1})
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
