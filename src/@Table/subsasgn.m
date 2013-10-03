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
        % one index: use linearised data
        if isa(value, 'Table')
            value = value.data;
        end
        this.data(s1.subs{1}) = value;

    elseif ns == 2
        % two indices: fill up with given value
        
        % analyze row indices
        sub1 = s1.subs{1};
        if ischar(sub1) || iscell(sub1)
            if ~strcmp(sub1, ':') 
                % parse the name of the row
                sub1 = rowIndex(this, sub1)';
                s1.subs{1} = sub1;
            end
        end
        
        % analyze column indices
        sub2 = s1.subs{2};
        if ischar(sub2) || iscell(sub2)
            if ~strcmp(sub2, ':')
                % parse the name of the column
                sub2 = columnIndex(this, sub2)';
                s1.subs{2} = sub2;
            end
        end
       
        % in case right-hand arg is a Table, extract its data
        if isa(value, 'Table')
            value = value.data;
        end
        
        % if right-hand arg is char, then it is a factor level
        if ischar(value)
            colLevels = this.levels{sub2};
            if ~ismember(value, colLevels)
                warning('Table:subsasgn:UnknownLevel', ...
                    'Level %s is not in the list of known levels, add it to current levels', value);
                % Add the new level to the list of levels for this column
                colLevels(length(colLevels)+1) = {value};
                this.levels{sub2} = colLevels;
            end
            
            % use index of specified level as value
            value = strmatch(value, colLevels);
        end
        
        % Assign the new value
        this.data(s1.subs{:}) = value;
        
        % if right-hand side is empty, need to update other data as well
        if isempty(value)
            if strcmp(sub1, ':')
                % remove some columns
                this.colNames(sub2) = [];
                if ~isempty(this.levels)
                    this.levels(sub2) = [];
                end
                
            elseif strcmp(sub2, ':') 
                % remove some rows
                this.rowNames(sub1) = [];
                
            else
                error('Illegal table modification');
            end
        end
        
    else
        error('Table:subsasgn', 'too many indices');
    end
    
else
    error('Table:subsasgn', 'can not manage such reference');
end

if nargout > 0
    varargout{1} = this;
end
