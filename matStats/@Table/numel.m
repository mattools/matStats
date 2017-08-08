function n = numel(varargin)
%NUMEL Overload default behaviour for the numel function
%
%   Returns always 1. This trick is necessary for being consistent with
%   subsasgn. 
%
%   See also
%   subsref, subsasgn

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

n = 1;
