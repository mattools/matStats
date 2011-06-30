function varargout = subsasgn(this, subs, value)
%SUBSASGN Overrides subsasgn function for Image objects
%   output = subsasgn(input)
%
%   Example
%   subsasgn
%
%   See also
%   subsref, end
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


s1 = subs(1);
type = s1.type;
if strcmp(type, '.')
    % in case of dot reference, use builtin
    
    % if some output arguments are asked, use specific processing
    if nargout > 0
        varargout = cell(1);
        varargout{1} = builtin('subsasgn', this, subs, value);    
    else
        builtin('subsasgn', this, subs, value);
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);
    if ns == 1
        % one index: use linearised image
        this.data(s1.subs{1}) = value;

    elseif ns == 2
        % two indices: fill up with given value
        
        % in case right-hand arg is a Table, extract its data
        if isa(value, 'Table')
            value = value.data;
        end
        this.data(s1.subs{:}) = value;
        
    else
        error('Table:subsasgn', 'too many indices');
    end
    
else
    error('Table:subsasgn', 'can not manage such reference');
end

if nargout > 0
    varargout{1} = this;
end
