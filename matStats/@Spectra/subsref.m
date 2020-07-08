function  varargout = subsref(obj, subs)
% Overrides subsref function for Spectra objects.
%
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
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
        [varargout{:}] = builtin('subsref', obj, subs);
        
    else
        % call parent function, and eventually return answer
        builtin('subsref', obj, subs);
        if exist('ans', 'var')
            varargout{1} = ans; %#ok<NOANS>
        end        
    end
    
    % stop here
    return;
    
elseif strcmp(type, '()')
    %% Process parens indexing
    
    % In case of parens reference, extract a sub-table from parent table.
    varargout{1} = 0;
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);    
        
    if ns == 2
        % two indices: extract corresponding table data
        
        % analyze row indices
        sub1 = s1.subs{1};
        if ischar(sub1) || iscell(sub1)
            if ~strcmp(sub1, ':') 
                % parse the name of the row
                inds = rowIndex(obj, sub1)';
                s1.subs{1} = inds;
            end
        end
        
        % analyze column indices
        sub2 = s1.subs{2};
        if ischar(sub2) || iscell(sub2)
            if strcmp(sub2, ':')
                % transform into numerical indices
                s1.subs{2} = 1:size(obj.Data, 2);
                
            else
                % parse the name of the column
                inds = columnIndex(obj, sub2)';
                s1.subs{2} = inds;
            end
        end
        
        % name of the new table
        newName = obj.Name;
        
        xvalues = [];
        if ~isempty(obj.XValues)
            xvalues = obj.XValues(s1.subs{2});
        end
        rowNames = {};
        if ~isempty(obj.RowNames)
            rowNames = obj.RowNames(s1.subs{1});
        end
        
        % extract corresponding data
        tab = Spectra(obj.Data(s1.subs{:}), ...
            'XValues', xvalues, ...
            'RowNames', rowNames, ...
            'Name', newName, ...
            'PlotType', obj.PlotType, ...
            'XAxisDir', obj.XAxisDir);
        
    else
        error('Spectra:subsref', 'Must specify two indices');
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
                inds = columnIndex(obj, s1.subs{1})';
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
                inds = rowIndex(obj, sub1)';
                s1.subs{1} = inds;
            end
        end
        
        % analyze column indices
        sub2 = s1.subs{2};
        if ischar(sub2) || iscell(sub2)
            if strcmp(sub2, ':')
                % transform into numerical indices
                s1.subs{2} = 1:size(obj.Data, 2);
                
            else
                % parse the name of the column
                inds = columnIndex(obj, sub2)';
                s1.subs{2} = inds;
            end
        end
        
    else
        error('Braces indexing requires one or two indices');
    end
    
    % At obj step, s1 is pre-processed and should eb able to index table
    % data directly
    
    % extract corresponding data
    tab = obj.Data(s1.subs{:});
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
