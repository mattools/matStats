function  varargout = subsref(this, subs)
%SUBSREF Overrides subsref function for Table objects
%
%   output = subsref(input)
%
%   Example
%   subsref
%
%   See also
%   subsasgn, end
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract reference type
s1 = subs(1);
type = s1.type;

% switch between reference types
if strcmp(type, '.')
    % in case of dot reference, use builtin
    
    % check if we need to return output or not
    if nargout>0
        % if some output arguments are asked, pre-allocate result
        varargout = cell(nargout, 1);
        [varargout{:}] = builtin('subsref', this, subs);
        
    else
        % call parent function, and eventually return answer
        builtin('subsref', this, subs);
        if exist('ans', 'var')
            varargout{1} = ans; %#ok<NOANS>
        end
        
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    varargout{1} = 0;
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);    
    if ns == 1
        % one index: use linearised data
        varargout{1} = this.data(s1.subs{1});
        
    elseif ns == 2
        % two indices: extract corresponding table data
        varargout{1} = this.data(s1.subs{:});
        
    else
        error('Table:subsref', 'too many indices');
    end
else
    error('Table:subsref', 'can not manage such reference');
end

