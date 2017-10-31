function  varargout = subsref(this, subs)
%SUBSREF Overrides subsref function for Table objects
%
%   RES = subsref(TAB, SUBS)
%   TAB is a Table object and SUBS is a structure following subsref syntax,
%   see Matlab's documentation for details. The result RES can be either
%   another table (in case of paren indexing), or a cell array (in case of
%   curly braces indexing).
%
%   TAB2 = TAB(ROWS, COLS);
%   Extract a sub-table from parent table TAB, using indices given by ROWS
%   or COLS.
%
%   Example
%     % Example of parens indexing returning another Table
%     iris = Table.read('fisherIris.txt');
%     tab2 = iris(1:3, :)
%     tab2 = 
%         SepalLength    SepalWidth    PetalLength    PetalWidth    Species
%     1           5.1           3.5            1.4           0.2     Setosa
%     2           4.9             3            1.4           0.2     Setosa
%     3           4.7           3.2            1.3           0.2     Setosa
%     class(tab2)
%     ans =
%       Table
%
%     % Example of curly braces indexing returning another cell array. In
%     % this case, the size of the result is 3-by-5.
%     iris = Table.read('fisherIris.txt');
%     res = iris{1:3, :}
%     res = 
%         [5.1000]    [3.5000]    [1.4000]    [0.2000]    'Setosa'
%         [4.9000]    [     3]    [1.4000]    [0.2000]    'Setosa'
%         [4.7000]    [3.2000]    [1.3000]    [0.2000]    'Setosa'
%     class(res)
%     ans =
%       cell
%
%     % Extract all levels from a factor
%     iris = Table.read('fisherIris.txt');
%     levels = unique(iris{'Species'})
%     levels = 
%         'Setosa'
%         'Versicolor'
%         'Virginica'
%
%   See also
%     subsasgn, end, getValue, getLevel

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.



%% extract reference type
s1 = subs(1);
type = s1.type;

% switch between reference types
if strcmp(type, '.')
    %% Process dot indexing
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
    %% Process parens indexing
    
    % In case of parens reference, index the inner data
    varargout{1} = 0;
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);    
    if ns == 1
        % one index: use either linearised data, or column name
        
        sub1 = s1.subs{1};
        
        % If indexing by table, string or cell array, determines the
        % corresponding numeric indices
        if isa(sub1, 'Table')
            % Manage indexing by another (logical) table
            siz = size(sub1);
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
            if strcmp(sub2, ':')
                % transform into numerical indices
                s1.subs{2} = 1:size(this.data, 2);
                
            else
                % parse the name of the column
                inds = columnIndex(this, sub2)';
                s1.subs{2} = inds;
            end
        end
        
        % name of the new table
        newName = this.name;
        
        % extract corresponding data
        tab = Table(this.data(s1.subs{:}), ...
            'rowNames', this.rowNames(s1.subs{1}), ...
            'colNames', this.colNames(s1.subs{2}), ...
            'levels', this.levels(s1.subs{2}), ...
            'name', newName);
        
    else
        error('Table:subsref', 'Too many indices');
    end
    
else
    %% Process braces indexing
    
    % Returns results in a cell array
    
    % In case of parens reference, index the inner data
    varargout{1} = 0;
    
    % switch processing depending on number of subs
    ns = length(s1.subs);
    if ns == 1
        % Assumes sub is the index or the name of a column

        inds = s1.subs{1};
        if ischar(inds) || iscell(inds)
            % if sub1 is a string (or a cell array of strings), try to find
            % indices of column(s) that correspond to that string(s)
            if ~strcmp(inds, ':')
                inds = columnIndex(this, s1.subs{1})';
            end
        end
        
        % convert column index/indices to 2 subs
        s1.subs = {':', inds};
        
        
    elseif ns == 2
        % If two subs are given, simply need to parse row and/or column
        % names if present
        
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
            if strcmp(sub2, ':')
                % transform into numerical indices
                s1.subs{2} = 1:size(this.data, 2);
                
            else
                % parse the name of the column
                inds = columnIndex(this, sub2)';
                s1.subs{2} = inds;
            end
        end
        
    else
        error('Braces indexing requires one or two indices');
    end
    
    % At this step, s1 is pre-processed and should eb able to index table
    % data directly
    
    % extract corresponding data, and transform into a cell array
    tab = num2cell(this.data(s1.subs{:}));
    
    % compute index of columns containing factors
    colInds = s1.subs{2};
    inds2 = find(isFactor(this, colInds));
    
    % additional processing for factors
    for iFact = 1:length(inds2)
        % get levels for current column
        iCol = colInds(inds2((iFact)));
        colLevels = this.levels{iCol};
        
        % add a default level in case of uninitialized value
        colLevels2 = [{'Unknown'} ; colLevels];
        
        % convert indices to level names, and put into result array
        levelIndices = this.data(s1.subs{1}, iCol);
        tab(:,inds2(iFact)) = colLevels2(levelIndices + 1);
    end
end


%% Additional processing of other subsref calls

if length(subs) == 1
    varargout = cell(nargout, 1);
    varargout{1} = tab;
    
else
    % check if we need to return output or not
    if nargout > 0
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
