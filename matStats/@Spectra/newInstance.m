function res = newInstance(obj, varargin) %#ok<INUSL>
% create a new instance of Spectra data set.
%
%   output = newInstance(input)
%
%   Example
%   newInstance
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-09,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2020 INRA - Cepia Software Platform.

res = Spectra.create(varargin{:});