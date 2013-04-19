function [this that parent names1 names2] = parseInputCouple(this, that, varargin)
%PARSEINPUTCOUPLE  One-line description here, please.
%
%   [DATA1 DATA2 PARENT NAMES1 NAMES2] = parseInputCouple(THIS, THAT)
%
%   ... = parseInputCouple(THIS, THAT, INPUTNAME1, INPUTNAME2)
%   Specifies input names from parent function.
%
%   Example
%   parseInputCouple
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract info from first input
if isa(this, 'Table')
    parent = this;
    names1 = this.colNames;
    this = this.data;
else
    parent = that;
    
    if isscalar(this)
        names1 = num2str(this);
    elseif ischar(this)
        names1 = this;
    else
        if ~isempty(varargin)
            names1 = varargin{1};
        else
            names1 = '...';
        end
    end
end

% extract info from second input
if isa(that, 'Table')
    names2 = that.colNames;
    that = that.data;
else
    if isscalar(that)
        names2 = num2str(that);
    elseif ischar(that)
        names2 = that;
    else
        if length(varargin) > 1
            names2 = varargin{2};
        else
            names2 = '...';
        end
    end
end
