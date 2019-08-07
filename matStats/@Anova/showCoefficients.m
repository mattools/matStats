function lines = showCoefficients(this)
%SHOWCOEFFICIENTS Display mean values of anova coefficients in a figure
%
%   showCoefficients(ANOVA)
%   Opens a new figure to display the results of an anova.
%
%
%   Example
%     % Compute Anova on Iris dataset, and display species coefficients
%     iris = Table.read('fisherIris');
%     res = Anova(iris('SepalLength'), iris('Species'));
%     showCoefficients(res);
%
%   See also
%     plotCoefficients
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

stats = this.Stats;
nCoefs = length(stats.coeffnames);

nChars = max(cellfun(@length, stats.coeffnames));
valFormat = createFormattingString(stats.coeffs);
format = [sprintf('%%-%ds: ', nChars) valFormat];


coeffFactorMatrix = stats.vars;

nCoefsByComb = stats.termcols;

nFactorCombs = length(nCoefsByComb); 


nLines = nCoefs + 3 * nFactorCombs;
lines = cell(nLines, 1);

iLine = 1;
iCoef = 1;

for i = 1:nFactorCombs
    lines{iLine} = '';
    iLine = iLine + 1;
    
    if iCoef == 1
        lines{iLine} = 'Intercept Value';
    else
        indFactors = find(coeffFactorMatrix(iCoef, :) > 0);
        if length(indFactors) == 1
            lines{iLine} = sprintf('Estimated values for factor %s', ...
                stats.varnames{indFactors(1)});
        else
            lines{iLine} = 'Estimated interactions';
        end
    end
    iLine = iLine + 1;
    
    for j = 1:nCoefsByComb(i)
        coeffName = stats.coeffnames{iCoef};
        
        indFactors = coeffFactorMatrix(iCoef, :);
        numFactors = sum(indFactors > 0);
        
        % initialize to the value of intercept
        fittedValue = stats.coeffs(1);

        % if current coefficient refers to an interaction, we need to
        % add the contributions of individual factors
        if numFactors > 1
            for k = 1:length(indFactors)
                level = coeffFactorMatrix(iCoef, k);
                if level == 0
                    continue;
                end
                
                ind = find(coeffFactorMatrix(:,k) == level, 1, 'first');
                fittedValue = fittedValue + stats.coeffs(ind);
            end
        end
        
        % also add the coefficient value
        if iCoef > 1
            fittedValue = fittedValue + stats.coeffs(iCoef);
        end
        
        lines{iLine} = sprintf(format, ...
            coeffName, fittedValue);
        
        iCoef = iCoef + 1;
        iLine = iLine + 1;
    end
end


% display result in a table
figure;
uicontrol(gcf, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'BackgroundColor', [1 1 1], ...
    'Max', 2, ...
    'HorizontalAlignment', 'left', ...
    'FontName', 'FixedWidth', ...
    'String', lines);


function format = createFormattingString(values)

nDigitsMax = 6;

% compute number of digits before and after the decimal separator
nSigDigits = ceil(max(log10(abs(values))));
nDecDigits = max(nDigitsMax - nSigDigits - 1, 0);

% number of significant digits
nDigits = nSigDigits + nDecDigits;

% add one digit for the sign
signDigit = '';
if any(values < 0)
    nDigits = nDigits + 1;
    signDigit = ' ';
end

% add one digit for the decimal separator
if any((values - floor(values)) > 0)
    nDigits = nDigits + 1;
end

% create formatting string
format = sprintf('%%%s%d.%df', signDigit, nDigits, nDecDigits);
