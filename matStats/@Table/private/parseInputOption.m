function [value, varList] = parseInputOption(name, varList, varargin)
%PARSEINPUTOPTION Extract the value of an option in varargin list
%
%   Usage:
%   [VALUE VARARGIN] = parseInputOption(NAME, VARARGIN)
%   [VALUE VARARGIN] = parseInputOption(NAME, VARARGIN, DEFAULTVALUE)
%
%   Example
%   parseInputOption
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% first defines default value (empty, or user-defined)
value = [];
if ~isempty(varargin)
    value = varargin{1};
end

% check if option is given
ind = find(strcmpi(varList(1:2:end), name));

% extract value, and remove processed options
if ~isempty(ind)
    value = varList{2*ind};
    varList(2*ind-1:2*ind) = [];
end
