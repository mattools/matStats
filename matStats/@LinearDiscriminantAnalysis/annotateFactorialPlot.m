function annotateFactorialPlot(obj, ax, cc1, cc2)
% Create labels and title of a factorial plot.
%
%   output = annotateFactorialPlot(input)
%
%   Example
%   annotateFactorialPlot
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.
% create legends

vl1 = obj.EigenValues(cc1, 2).Data;
vl2 = obj.EigenValues(cc2, 2).Data;

xlabel(ax, sprintf('Canonical Axis %d (%5.2f %%)', cc1, vl1));
ylabel(ax, sprintf('Canonical Axis %d (%5.2f %%)', cc2, vl2));

title(ax, obj.TableName, 'interpreter', 'none');
