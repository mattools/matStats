function res = eq(this, that)
%EQ  Overload the eq operator for Table objects
%
%   output = eq(input)
%
%   Example
%   eq
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if sum(isFactor(this, 1:size(this.data, 2))) > 0
    error('Can not compute eq for table with factors');
end

% extract info from first input
if isa(this, 'Table')
    parent = this;
    names1 = this.colNames;
    this = this.data;
else
    parent = that;
    names1 = inputname(1);
    if isempty(names1) 
        if isscalar(this)
            names1 = num2str(this);
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
    names2 = inputname(2);
    if isempty(names2) 
        if isscalar(that)
            names2 = num2str(that);
        else
            names2 = '...';
        end
    end
end

% compute new data
newData = bsxfun(@eq, this, that);

newColNames = strcat(names1, '==', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
