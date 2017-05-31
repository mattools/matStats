%% Using the Table Class
%  This is a demo file for presenting some features of the Table class.
%
%   Usage:
%     demoTable
%

%% Read and display data

% Read data from a csv file (several options can be specified)
tab = Table.read('fisherIris.txt');

% display a part of the table on the console
disp(tab(1:5, :));

% Or display summary of the data, like in R
summary(tab);

% display the table in a frame
show(tab);


%% Plotting functions

% box plot of the quantitative variables
figure;
boxplot(tab(:,1:4));

% histogram of petal length. Columns can be indexed by their name.
figure;
hist(tab('PetalLength'));

% plot petal width against petal length
figure;
plot(tab('PetalLength'), tab('PetalWidth'), '*');


%% Management of groups

% scatter plot using groups
figure;
scatterGroup(tab('PetalLength'), tab('PetalWidth'), tab('Species'), ...
    'Envelope', 'InertiaEllipse', ...
    'LegendLocation', 'NorthWest');

% Compute the mean of each group
disp(aggregate(tab(:,1:4), tab('Species'), @mean));


%% Principal Component Analysis

% Apply Principal Component Analysis on the quantitative variables
irisPca = Pca(tab(:, 1:4), 'display', 'off');

% The result is a Pca object, containing Table object for scores, loadings
% and eigen values
disp(irisPca);

% Score plot can be displayed with automatic labeling of axes
figure;
scorePlot(irisPca, 1, 2);

% Loadings can also be displayed with automatic labeling
figure;
loadingPlot(irisPca, 1, 2);

% To display scores with group labelling, simply call the plot method on
% the score object stored in Pca result
figure;
scatterGroup(irisPca.scores(:, 1), irisPca.scores(:, 2), tab('Species'), ...
    'LegendLocation', 'NorthWest');

