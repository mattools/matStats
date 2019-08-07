function coeffs = coefficients(this, factorName)
%COEFFICIENTS Return the coefficients computed for a factor
%
%   coefficients(ANOVA)
%   plotCoefficients(ANOVA, FACTORNAME)
%
%   Example
%     % Compute Anova on Iris dataset, and display species coefficients
%     iris = Table.read('fisherIris');
%     res = Anova(iris('SepalLength'), iris('Species'));
%     coefficients(res, 'Species')
%     ans =
%                               1
%         Setosa            5.006
%         Versicolor        5.936
%         Virginica         6.588
%
%     
%   See also
%     showCoefficients, 
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

if iscell(factorName) && length(factorName) > 1
    error('Can process only one factor');
end

if ~strcmp(this.Stats.varnames, factorName)
    error(['Could not identify the factor: ' factorName]);
end

% index of the factor in the list of ANOVA factors
indFactor = find(strcmp(this.Stats.varnames, factorName));

% levels of the factor (for populating results table)
levels = this.Stats.grpnames{indFactor};
nLevels = this.Stats.nlevels(indFactor);


%% Compute coefficient for each level

% get global effect of the anova
intercept = this.Stats.coeffs(1);

% number of terms before the terms of the current factor
coeffOffset = sum(this.Stats.termcols(1:indFactor));

coeffs = Table(zeros(nLevels, 1), {this.VarName});

for i = 1:nLevels
    % inedx of coefficient in the coefficient matrix
    indCoeff = coeffOffset + i;
    
    coeffs(i) = intercept + this.Stats.coeffs(indCoeff);
    
    coeffs.RowNames{i} = levels{i};
end

