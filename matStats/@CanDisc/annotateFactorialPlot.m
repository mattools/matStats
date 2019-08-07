function annotateFactorialPlot(this, ax, cc1, cc2)
%ANNOTATEFACTORIALPLOT Create labels and title of a factorial plot
%
%   output = annotateFactorialPlot(input)
%
%   Example
%   annotateFactorialPlot
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.
% create legends

vl1 = this.EigenValues(cc1, 2).Data;
vl2 = this.EigenValues(cc2, 2).Data;

xlabel(ax, sprintf('Canonical Axis %d (%5.2f %%)', cc1, vl1));
ylabel(ax, sprintf('Canonical Axis %d (%5.2f %%)', cc2, vl2));

title(ax, this.TableName, 'interpreter', 'none');
