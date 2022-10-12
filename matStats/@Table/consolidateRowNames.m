function consolidateRowNames(obj, varargin)
% Ensure the table have consistent RowNames property.
%
%   consolidateRowNames(TAB)
%   Ensure the Table object TAB has valid row names:
%   * same length as the number of rows of data, 
%   * no empty row cells
%   * if some row names were specified, they are kept as is.
%   
%
%   Example
%     consolidateRowNames(tab);
%
%   See also
%      disp, write.
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2022-10-12,    using Matlab 9.13.0.2049777 (R2022b)
% Copyright 2022 INRAE.

obj.RowNames = consolidatedRowNames(obj, varargin{:});
