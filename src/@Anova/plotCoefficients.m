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


%% Process input arguments

if iscell(factorName) && length(factorName) > 1
    error('Can process only one factor');
end

if ~strcmp(this.stats.varnames, factorName)
    error(['Could not identify the factor: ' factorName]);
end

indFactor = find(strcmp(this.stats.varnames, factorName));

nLevels = this.stats.nlevels(indFactor);

levels = this.stats.grpnames{indFactor};


%% Compute coefficient for each level

% get global effect of the anova
intercept = this.stats.coeffs(1);

% number of terms before the terms of the current factor
coeffOffset = sum(this.stats.termcols(1:indFactor));

coeffs = Table(zeros(nLevels, 1));

for i = 1:nLevels
    % inedx of coefficient in the coefficient matrix
    indCoeff = coeffOffset + i;
    
    coeffs(i) = intercept + this.stats.coeffs(indCoeff);
    
    coeffs.rowNames{i} = levels{i};
end


%% Display

figure;
plot(1:nLevels, coeffs.data);
xlim([0 nLevels+1]);
xlabel(factorName);
set(gca, 'xtick', 1:nLevels);
set(gca, 'xticklabel', levels);

