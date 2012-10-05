function annotateFactorialPlot(this, cp1, cp2)
%ANNOTATEFACTORIALPLOT  create labels and title of a factorial plot
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

vl1 = this.eigenValues(cp1, 2).data;
vl2 = this.eigenValues(cp2, 2).data;

xlabel(sprintf('Principal component %d (%5.2f %%)', cp1, vl1));
ylabel(sprintf('Principal component %d (%5.2f %%)', cp2, vl2));

title(this.tableName, 'interpreter', 'none');