function [data1, data2, parent, names1, names2] = parseInputCouple(obj1, obj2, varargin)
% From two input args, parse the data, one parent table, and col names.
%
%   [DATA1, DATA2, PARENT, NAMES1, NAMES2] = parseInputCouple(ARG1, ARG2)
%   From the two input arguments ARG1 and ARG2, extracte numerical arrays
%   and column names as follow:
%   * If ARGi is a data table, returns its data into DATAi, and the column
%   names in NAMESi
%   * If ARGi is numeric, returns DATAi=ARGi, and compute a char array
%   representation of ARGi
%   * If ARG1 is a "Table" object, then PARENT corresponds to ARG1.
%       Otherwise ARG2 is assumed to be a Table object, and PARENT=ARG2.
%
%   ... = parseInputCouple(ARG1, ARG2, INPUTNAME1, INPUTNAME2)
%   Specifies input names from parent function, making it possibe to have
%   better labels for arguments.
%
%   Example
%   parseInputCouple
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-08-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% default data
names1 = '(?)';
names2 = '(?)';

% extract info from first input
if isa(obj1, 'Table')
    parent = obj1;
    data1 = obj1.Data;
    if ~isempty(obj1.ColNames)
        names1 = obj1.ColNames;
    end
else
    parent = obj2;
    
    data1 = obj1;
    if isscalar(obj1)
        names1 = num2str(obj1);
    elseif ischar(obj1)
        names1 = obj1;
    else
        if ~isempty(varargin)
            names1 = varargin{1};
        end
    end
end

% extract info from second input
if isa(obj2, 'Table')
    data2 = obj2.Data;
    if ~isempty(obj2.ColNames)
        names2 = obj2.ColNames;
    end
else
    data2 = obj2;
    if isscalar(obj2)
        names2 = num2str(obj2);
    elseif ischar(obj2)
        names2 = obj2;
    else
        if length(varargin) > 1
            names2 = varargin{2};
        end
    end
end
