%DEMO_LDA_IRIS Demonstration of Linear Discriminant Analysis
%
%   demo_LDA_iris
%
%   See Also
%     LinearDiscriminantAnalysis
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-11-03,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.


%% Apply PCA on Iris data set

% Read data from a csv file
iris = Table.read('fisherIris.txt');

% display a short summary
info(iris);

% split into quantitative and categorical variables
data = iris(:, 1:4);
species = iris('Species');

%% Apply Linear Discriminant Analysis

% Apply Principal Component Analysis on the quantitative variables
irisLda = LinearDiscriminantAnalysis(data, species);

% The result is a LinearDiscriminantAnalysis object, containing Table
% object for scores, loadings and eigen values
disp(irisLda);

