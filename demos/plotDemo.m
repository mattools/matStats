% Demonstration of plotting features of the MatStats library.
%
%   output = plotDemo(input)
%
%   Example
%   plotDemo
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-07-01,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


%% Generate demo Table
% Generate a data table containing three columns, corresponding to a dummy
% parametrisation variable, and the result of two functions, here sine and
% cosine functions. 

% parametrisation (as vertical vector)
t = linspace(0, 2*pi, 100)';

% concatenate as a numerical array
data = [t cos(t) sin(t)];

% create the Data Table encapsulating the data. Also specifies the name to
% populate the 'title' of the figures
tab = Table(data, {'t', 'Cosine', 'Sine'}, 'Name', 'Sine and Cosine');


%% Line Plot

figure; set(gca, 'FontSize', 14);
linePlot(tab(:,1), tab(:, 2:3));


%% Stair Steps Plot

figure; set(gca, 'FontSize', 14);
stairStepsPlot(tab(:,1), tab(:, 2:3));


%% Line Plot

figure; set(gca, 'FontSize', 14);
stemPlot(tab(:,1), tab(:, 2:3));
