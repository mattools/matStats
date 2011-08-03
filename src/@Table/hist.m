function varargout = hist(this, varargin)
%HIST Histogram plot of a column in a data table
%
%   hist(TAB)
%   Displays histogram of table obejct TAB, that is assumed to contains
%   only one column.
%
%
%   Example
%   histogram
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


data = this.data;

% scatter plot of selected columns
hist(data, varargin{:});
xlabel(this.colNames{1});

if ~isempty(this.name)
    title(this.name);
end

% eventually returns handle to graphics
if nargout>0
    varargout{1} = h;
end
