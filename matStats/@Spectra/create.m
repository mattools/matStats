function tab = create(data, varargin)
% Create a new Spectra data set.
%
%   TAB = Spectra.create(DATA)
%   where DATA is a numeric array, creates a new spectra data set
%   initialized with the content of the array.
%
%   TAB = Spectra.create(DATA, XVALUES)
%   where XVALUES is a numeric array, creates a new spectra data set using
%   the specified array as display reference for x-axis.
%
%   TAB = Spectra.create(..., 'RowNames', NAMES)
%   Also specifies the name of rows. NAMES is a cell array with as many
%   columns as the number of rows of the data table.
%
%   TAB = Spectra.create(..., 'Name', NAME)
%   Also specify the name of the data table. NAME is a char array.
%
%   Example
%     % create data table with direct initialization of the fields
%     dat = rand(4, 3);
%     xvalues = [10 20 30];
%     tab = Spectra.create(dat, 'XValues', xvalues);
%     tab.show();
%
%
%   See also
%     Spectra, read, write
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-04-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Setup data

% first argument is assumed to contain data
tab = Spectra(data, varargin{:});
    
