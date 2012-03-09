function styles = generateMarkerStyles(n)
% Generate NG different marker styles. 
% Result is a cell array of cell arrays.
% First array is a 1-by-NG cell array
% Each sub-cell is a cell array of parameter name-value pairs.
%

% generate Nc+1 colors. The last one is white, but is not used
if n < 8
    map = [0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
else
    map = colormap(colorcube(Nc+1));
end

% the basic set of marks
marks = {'+', 'o', '*', 'x', 's', 'd', '^', 'v', '<', '>', 'p', 'h'};

% create the basic style of each line
styles = cell(n, 1);
for i = 1:n
    styles{i} = {...
        'lineStyle', 'none', ...
        'color', map(i, :) ...
        'marker', marks{mod(i-1, length(marks))+1} } ;
end
