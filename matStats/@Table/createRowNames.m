function createRowNames(obj, varargin)
% Create default row names for table.
%
%   createRowNames(TAB)
%
%   Example
%     data = reshape(1:12, [3 4])';
%     tab = Table(data, {'C1', 'C2', 'C3'});
%     createRowNames(tab, 'row%02d');
%     tab
%     tab = 
%                  C1    C2    C3
%     row01         1     2     3
%     row02         4     5     6
%     row03         7     8     9
%     row04        10    11    12
%
%   See also
%     create, parseFactorFromRowNames
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-12-12,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2019 INRA - Cepia Software Platform.

nr = size(obj.Data, 1);

format = '%d';
if ~isempty(varargin)
    format = varargin{1};
end

obj.RowNames = strtrim(cellstr(num2str((1:nr)', format)));
