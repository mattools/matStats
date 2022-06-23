%% Generate figures for the Table class manual
%
%   Usage:
%     demoTable
%
% started 2017-05-31

%% Read and display data

% Read data from a csv file (several options can be specified)
tab = Table.read('fisherIris.txt');

% display a part of the table on the console
disp(tab(1:5, :));

% Or display summary of the data, like in R
summary(tab);

% display the table in a frame
show(tab);

%% Histograms

% histogram of petal length. Columns can be indexed by their name.
figure;
histogram(tab('PetalLength'), 30);
print(gcf, 'iris_petalLength_hist.png', '-dpng');


% plot values of petal length
figure;
plot(tab('PetalLength'), 'bs');
print(gcf, 'iris_plotPetalLength_sq.png', '-dpng');

% plot petal width against petal length
figure;
plot(tab('PetalLength'), tab('PetalWidth'), 'b*');
print(gcf, 'iris_petalWidth_petalLength_star.png', '-dpng');


%% Box and violin plots

% box plot of the quantitative variables
figure;
boxplot(tab(:,1:4));
print(gcf, 'iris_boxPlot.png', '-dpng');

figure;
violinPlot(tab(:,1:4));
print(gcf, 'iris_violinPlot.png', '-dpng');


%% Management of groups

% scatter plot using groups
figure;
scatterGroup(tab('PetalLength'), tab('PetalWidth'), tab('Species'), ...
    'Envelope', 'InertiaEllipse', ...
    'LegendLocation', 'NorthWest');

% Compute the mean of each group
meanByGroup = aggregate(tab(:,1:4), tab('Species'), @mean);
disp(meanByGroup);

% display as bar plot
figure;
bar(meanByGroup');
print(gcf, 'iris_meanByGroup_bar.png', '-dpng');


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
scatterGroup(irisPca.Scores(:, 1), irisPca.Scores(:, 2), tab('Species'), ...
    'LegendLocation', 'NorthWest');
