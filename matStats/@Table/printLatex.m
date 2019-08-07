function printLatex(this, varargin)
%PRINTLATEX Print content of this table as a latex tabular
%
%   output = printLatex(input)
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     printLatex(iris(1:10, :));
%
%   See also
%     display
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-08-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% display to standard output
fid = 1;

% size of the table
nRows = size(this, 1);
nCols = size(this, 2);


% Eventually writes document header
% fprintf(fid, '\\documentclass{article}\n');
% fprintf(fid, '\\begin{document}\n');

% write table header
fprintf(fid, '\\begin{tabular}{ }\n');

fprintf(fid, 'name');
for iCol = 1:nCols
    fprintf(fid, [' & ' this.ColNames{iCol}]);
end
fprintf(fid, ' \\\\ \n');

fprintf(fid, '\\hline\n');

for iRow = 1:nRows
    
    % print first item
    fprintf(fid, '%s', this.RowNames{iRow});

    % print all remaining items
    for iCol = 1:nCols
        fprintf(fid, ' & ');
        fprintf(fid, '%s', formatEntry(iRow, iCol));
    end
    
    fprintf(fid,' \\\\ \n');
end


fprintf(fid,'\\hline\n');
fprintf(fid,'\\end{tabular}\n');

% Eventually writes the end of the documet
% fprintf(fid,'\\end{document}\n');

    function entry = formatEntry(iRow, iCol)
        % Formating function that returns a clean string
        if isFactor(this, iCol)
            ind = this.Data(iRow, iCol);
            level = this.Levels{iCol}{ind};
            entry = level;
        else
            entry = sprintf('%g', this.Data(iRow, iCol));
        end
    end
end

