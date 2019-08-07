function varargout = scatterLabels(this, var1, var2, labels, varargin)
%SCATTERLABELS Scatter labels according to 2 variables
%
%   Note: should consider scatterNames as a replacement for this function.
%
%   scatterLabels(TAB, VAR1, VAR2, LABELS)
%   where TABLE is a Table object, and VAR1 and VAR2 are either indices or
%   names of 2 columns in the table, scatter the individuals given with
%   given coordinates
%
%   scatterLabels(..., PARAM, VALUE)
%   Specifies drawing options
%
%   Example
%   scatterLabels
%
%   See also
%     scatterNames, scatterPlot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Process input arguments

% index of first column
ind1 = this.ColumnIndex(var1);
col1 = this.Data(:, ind1(1));

% index of second column
ind2 = this.ColumnIndex(var2);
col2 = this.Data(:, ind2(1));

% default values for options
fontSize = 8;
interpreter = 'none';

xlabelText = this.ColNames{ind1};
ylabelText = this.ColNames{ind2};

% parse optional arguments
options = {};
while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'fontsize'
            fontSize = varargin{2};
        case 'interpreter'
            interpreter = varargin{2};
        case 'xlabel'
            xlabelText = varargin{2};
        case 'ylabel'
            ylabelText = varargin{2};
        otherwise
            % assumes these are options for the 'text' function
            options = [options {paramName, varargin{2}}]; %#ok<AGROW>
    end

    varargin(1:2) = [];
end


%% Pre-processing

% if labels is the name of a column, interpret it
if size(labels, 1)==1 && ischar(labels)
    indLabels = this.ColumnIndex(var2);
    labels = this.Data(:, indLabels(1));
end

% labels can also be the index of a column
if length(labels)==1 && isnumeric(labels)
    indLabels = this.ColumnIndex(var2);
    labels = this.Data(:, indLabels(1));
end

% ensure labels are given as text
if isnumeric(labels)
    labels = strtrim(cellstr(num2str(labels(:))));
end


%% Display graph and decorate

% scatter names of selected columns
plot(col1, col2, 'w.');
h = text(col1, col2, labels, 'FontSize', fontSize, options{:});

% add plot annotations
xlabel(xlabelText);
ylabel(ylabelText);

if ~isempty(this.Name)
    title(this.Name, 'Interpreter', interpreter);
end

% eventually returns handle to graphics
if nargout > 0
    varargout = {h};
end
