function plotCoefficients(this, factorName)
%PLOTCOEFFICIENTS  Plot the coefficients of a given factor
%
%   plotCoefficients(ANOVA, FACTORNAME)
%
%   Example
%     % Compute Anova on Iris dataset, and display species coefficients
%     iris = Table.read('fisherIris');
%     res = Anova(iris('SepalLength'), iris('Species'));
%     plotCoefficients(res, 'Species');
%     
%   See also
%     showCoefficients
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-05-30,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

coeffs = coefficients(this, factorName);
nLevels = size(coeffs, 1);

%% Display

% plot as curve
figure;
plot(1:nLevels, coeffs.data);
xlim([0 nLevels+1]);

% annotate the graph
xlabel(factorName);
set(gca, 'xtick', 1:nLevels);
set(gca, 'xticklabel', coeffs.rowNames);

