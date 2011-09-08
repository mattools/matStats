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
    if nargout > 0
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
    
    % stop here
    return;
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    varargout{1} = 0;
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);    
    if ns == 1
        % one index: use either linearised data, or column name
        
        sub1 = s1.subs{1};
        
        % Manage indexing by another (logical) table
        if isa(sub1, 'Table')
            siz = size(s1.subs{1});
            if siz(2) > 1
                % if indexing table has several columns, use linear
                % indexing 
                s1.subs = {find(sub1.data > 0)};
            else
                % if indexing table has only one column, use it for row
                % indexing
                s1.subs = {find(sub1.data > 0), ':'};
            end
        
        elseif ischar(sub1) || iscell(sub1)
            % if sub1 is a string (or a cell array of strings), try to find
            % indices of column(s) that correspond to that string(s)
            if ~strcmp(sub1, ':')
                inds = columnIndex(this, s1.subs{1})';
                
                % transform to 2 indices indexing
                s1.subs = {':', inds};
            end
        end
        
        % compute result, that can be either a new table, or a set of
        % values (in case of linear indexing)
        if length(s1.subs) == 1
            tab = subsref(this.data, s1);
        else
            tab = subsref(this, s1);
        end
        
    elseif ns == 2
        % two indices: extract corresponding table data
        
        % analyze row indices
        sub1 = s1.subs{1};
        if ischar(sub1) || iscell(sub1)
            if ~strcmp(sub1, ':') 
                % parse the name of the row
                inds = rowIndex(this, sub1)';
                s1.subs{1} = inds;
            end
        end
        
        % analyze column indices
        sub2 = s1.subs{2};
        if ischar(sub2) || iscell(sub2)
            if ~strcmp(sub2, ':')
                % parse the name of the column
                inds = columnIndex(this, sub2)';
                s1.subs{2} = inds;
            end
        end
        
        % name of the new table
        newName = this.name;
        
        % extract corresponding data
        tab = Table.create(this.data(s1.subs{:}), ...
            'rowNames', this.rowNames(s1.subs{1}), ...
            'colNames', this.colNames(s1.subs{2}), ...
            'levels', this.levels(s1.subs{2}), ...
            'name', newName);
        
    else
        error('Table:subsref', 'Too many indices');
    end
    
else
    error('Table:subsref', 'Can not manage such reference');
end

% Additional processing of other subsref calls
if length(subs) == 1
    varargout{1} = tab;
else
    % check if we need to return output or not
    if nargout>0
        % if some output arguments are asked, pre-allocate result
        varargout = cell(nargout, 1);
        [varargout{:}] = subsref(tab, subs(2:end));
        
    else
        % call parent function, and eventually return answer
        subsref(tab, subs(2:end));
        if exist('ans', 'var')
            varargout{1} = ans; %#ok<NOANS>
        end
        
    end
    
end
