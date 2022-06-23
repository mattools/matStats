%ANOVAIRIS  Performs sample Anova on Iris data set
%
%   output = anovaIris(input)
%
%   Example
%   anovaIris
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-07-19,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% Analysis of variance on Fisher's iris
iris = Table.read('fisherIris');
anovaPL = Anova(iris('PetalLength'), iris('Species'));

%% display fitted coefficients
coefficients(anovaPL, 'Species')
% ans = 
%                   PetalLength
% Setosa                  1.462
% Versicolor               4.26
% Virginica               5.552


%% Display residuals

plotResiduals(anovaPL);
print(gcf, 'anova-irisPL-resids.png', '-dpng');

%% Display residual by factor level

figure; set(gca, 'fontsize', 14);
plot(iris('Species'), residuals(anovaPL), 'bs');
hold on;
plot([.5 3.5], [0 0], 'k-');
print(gcf, 'anova-irisPL-residsBySpecies.png', '-dpng');
