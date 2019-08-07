function tf = logical(this)
%LOGICAL Convert to logical array
%
%   TF = logic(TAB)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     test = iris('PetalLength') > 2;
%     test2 = logical(test);
%
%   See also
%     eq, ne
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2015-08-24,    using Matlab 8.5.0.197613 (R2015a)
% Copyright 2015 INRA - Cepia Software Platform.

tf = this.Data ~= 0;
