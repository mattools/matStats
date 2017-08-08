function save(this, baseName)
%SAVE Save the result of the PCA into several files
%
%   output = save(input)
%
%   Example
%   save
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


if nargin < 2
    baseName = [this.tableName '-pca'];
end

[path, name] = fileparts(baseName);
baseName = fullfile(path, name);


%% Save a generic file

f = fopen([baseName '.txt'], 'wt');
fprintf(f, 'Result of Principal Component Analysis\n');
fprintf(f, '\n');

fprintf(f, 'Original data file:  %s\n', this.tableName);
if this.scaled, str = 'yes'; else str = 'no'; end
fprintf(f, 'Data scaling: %s\n', str);

fprintf(f, '\n');
fprintf(f, 'Scores:     %s.scores.txt\n', name);
fprintf(f, 'Loadings:   %s.loadings.txt\n', name);
fprintf(f, 'Values:     %s.values.txt\n', name);

fprintf(f, '\n');
fprintf(f, '%s\n', datestr(now));

fclose(f);


%% Save 3 result files corresponding to Scores, loadings and eigen values

% save score array (coordinates of individuals in new basis)
fileName = [baseName '.scores.txt'];
write(this.scores, fileName);

% save loadings array (corodinates of variable in new basis)
fileName = [baseName '.loadings.txt'];
write(this.loadings, fileName);

% save eigen values array
fileName = [baseName '.values.txt'];
write(this.eigenValues, fileName);
