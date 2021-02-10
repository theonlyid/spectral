%% Load data
load('.\data\sleep\RC_051_sleep.mat')

%% Import libraries
np = py.importlib.import_module('numpy');
sc = py.importlib.import_module('spectral.contrast');

%% Specify data-specific arguments
args_con = pyargs('fs', int32(1000), 'nperseg', int32(2048), 'noverlap', int32(128), 'fmin', int32(0), 'fmax', int32(30));
% Note: frequency resolution is fs/nperseg

%% Crunch the numbers
tic;
res = sc.contrast(data, y, args_con);
time = toc;

disp("Time taken: " + time + " seconds")
% On my machine: time taken was 71 seconds. Please try on yours.

snr = np.array(res(1)); % convert tuple-object into Numpy array
snr = double(snr); % convert numpy array into Matlab array
snr = squeeze(snr); % remove extra dimensions
f = double(squeeze(np.array(res(2))));

%% Plot results
figure()
pcolor(f, f, snr); colorbar(); colormap('jet');
