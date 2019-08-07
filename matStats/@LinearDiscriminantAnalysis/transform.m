function res = transform(this, data)
%TRANSFORM Transform new data to canonical space
%
%   RES = transform(LDA, DATA)
%
%   Example
%     lda = LinearDiscriminantAnalysis(iris(:,1:4), iris('Species'));
%     scores = transform(lda, iris(:,1:4));
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-11-03,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.


% name of new columns
nDims = size(this.Loadings, 2);
varNames = strtrim(cellstr(num2str((1:nDims)', 'cc%d')));

% compute new name
name = 'Can. Coords';
if ~isempty(this.TableName)
    name = sprintf('Can. Coords of %s', this.TableName);
end

% Table object for canonical coordinates
res = Table.create(data.Data * this.Loadings.data, ...
    'rowNames', data.RowNames, ...
    'colNames', varNames, ...
    'name', name);
