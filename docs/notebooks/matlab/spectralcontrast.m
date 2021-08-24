%% Accessing the Spectral module through Matlab 2019b
% This notebooks is a simple example on how to call various methods from the 
% Spectral python library.
% 
% To open this file as a live script, simly right click on the file (spectralcontrast.m) 
% file and select 'Open as Live Script'.
%% Importing python libraries
% Python libraries can be imported using the importlib util. To make sure your 
% python interpreter is configured correctly, use "|*py.help('numpy')*|" to ensure 
% all required dependencies are in your path.
% 
% If that returns a list of NumPy methods along with a version and path, we're 
% good to go. Start by importing the necessary python modules

% Import libraries
np = py.importlib.import_module('numpy');
sc = py.importlib.import_module('spectral.contrast');
% Passing keyword arguments to Python
% Python converts keyword arguments to dictionaries. For Matlab users, keyword 
% arguments need to be converted to a python object using |*pyargs*|. This function 
% coverts Matlab keywords to Python keywords, enabling smooth passing of arguments.
% 
% Use "|*doc pyargs"*| for more details.

% Specify keyword arguments for python methods
args_gen = pyargs('fs', int32(1000), 'nchans', int32(10), 'nsamples', int32(2000));

% Use it to call a method
data = sc.simulate_recording(args_gen);
y = [ones(1,5), zeros(1,5)];

% Specify data-specific arguments
args_con = pyargs('fs', int32(1000), 'nperseg', int32(64), 'noverlap', int32(32));
res = sc.contrast(data, y, args_con);
%% 
% We've captured the result returned by |sc.contrast()| in |res|. In case we'd 
% like to know what |sc.contrast()| returns, we can always invoke Python's help 
% command (since the funtion is in Python).

py.help(sc.contrast)
%% 
% The docstring says that it returns two arrays, snr and f. If we check the 
% Matlab Workspace, we see that '|res'| has a value: |1x2 tuple|.
% 
% These are teh 'snr' and 'f' arrays, respectively. So, the original arrays 
% can be retrieved by indexing into res.

res(2)
%% 
% Python returns results to Matlab as Python objects. These need to be cast 
% into Matlab compatible variables. There is no default code for this, and you 
% need to ensure you know what the Python method's return, in order to interpret 
% the results.
% 
% In this case, we know contrast returns snr, and f. And we know these are arrays. 
% So we can retrieve their Matlab compatible versions:

% convert arrays back to matlab-readable formats
snr = np.array(res(1)); % convert tuple-object into Numpy array
snr = double(snr); % convert numpy array into Matlab array
snr = squeeze(snr); % remove extra dimensions
%% 
% Python sometimes adds metadata to arrays for more information, but in our 
% case, the extra dimension is empty, so we just squeeze the arrays.
% 
% We can do all the above steps together in a single step:

f = double(squeeze(np.array(res(2))));
%% 
% Plotting the snr is super easy,

surf(f(1:end-1, f(1:end), snr)); colormap('jet');