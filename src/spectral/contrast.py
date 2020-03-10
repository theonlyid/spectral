""" 
A module for analysis using the spectral decomposition of timeseries data.

Version 1.0;
Author: Ali Zaidi
"""

# IMPORT DEPENDENCIES

from __future__ import absolute_import, print_function
import numpy as np
from scipy import signal

# Code starts here
def get_norm_array(data, **kwargs):
    """
    Returns the normalization array for timeseries data.
    
    Parameters
    ----------
    data: array, timeseries data [nchan x nobs x ntrials]
    *fs: int, sampling frequency in Hz
    *nperseg: int, number of timepoints for stft window
    *noverlap: int, number of timepoints for window overlap

    Returns
    -------
    norm_array: normalized array with mean power per frequency [nchan x freqs]
    """

    # Read stft params from function arguments
    if 'fs' in kwargs.items(): fs=kwargs['fs']
    else: fs = 1000

    if 'nperseg' in kwargs.items(): noverlap=kwargs['nperseg']
    else: nperseg = 64

    if 'noverlap' in kwargs.items(): noverlap=kwargs['noverlap']
    else: noverlap = 3*(nperseg//4)

    # Get the STFT of the signals
    f, _, data_stft = signal.stft(
        data, fs=fs, nperseg=nperseg, noverlap=noverlap, axis=1)

    data_stft = np.moveaxis(np.abs(data_stft), 2, 3)  # last axis is now ntrials
    data_stft = data_stft[:, :, 1:-1, :]              # purge STFT flanks

    # Average across trials and time-bins
    data_stft_mean = np.mean(np.abs(data_stft), axis=-1)    # trials
    norm_array = np.mean(np.abs(data_stft_mean), axis=-1)   # timebins

    return norm_array

def get_stft(data_array, norm_array=[], normalize=True, **kwargs):
    """
    Returns the STFT for timeseries data.
    
    Parameters
    -----------
    data_array: array
        timeseries data [nchan x nobs x ntrials]
    norm_array: array
        for spectral normalization (see `get_norm_array()`)
    *fs: int
        sampling frequency in Hz
    *nperseg: int
        number of timepoints for stft window
    *noverlap: int
        number of timepoints for window overlap
        
    Returns
    -------
    stft_array: array
        STFT of the input array [nchan x nfreqs x nobs x trials]
    f: array
        an array of the frequencies of the STFT transform
    """
    # Read stft params from function arguments
    if 'fs' in kwargs.items(): fs=kwargs['fs']
    else: fs = 1000

    if 'nperseg' in kwargs.items(): noverlap=kwargs['nperseg']
    else: nperseg = 64

    if 'noverlap' in kwargs.items(): noverlap=kwargs['noverlap']
    else: noverlap = 3*(nperseg//4)

    # Calculate the short-time fourrier transform
    f, _, data_stft = signal.stft(
        data_array, fs=fs, nperseg=nperseg, noverlap=noverlap, axis=1)
    
    # Make last axis as trials
    data_stft = np.moveaxis(np.abs(data_stft), 2, 3)
    data_stft = data_stft[:,:,1:-1,:]

    if normalize:
        # Facilitate vectorized division
        norm_array_data = np.repeat(norm_array[:, :, np.newaxis], data_stft.shape[-2], axis=-1)
        norm_array_data = np.repeat(norm_array_data[:, :, :, np.newaxis], data_stft.shape[-1], axis=-1)

        # Normalize the spectrograms for calculating SNR
        data_stft_norm = data_stft / norm_array_data

        return data_stft_norm, f

    else:
        return data_stft, f

def get_bands(target_stft_norm, baseline_stft_norm, f):
    """
    Calculates the mean power across all possible combinations of frequencies for each channel.
    
    Parameters
    ----------
    target_stft_norm: array
        stft decomposed target array [nchan x nfreqs x nobs x ntrials]
    baseline_stft_norm: array
        stft decomposed baseline array [nchan x nfreqs x nobs x ntrials]
    f: array
        vector of frequencies obtained from STFT transform (see `get_stft()`).
    
    Returns
    -------
    target_bands: array
        array of mean power across all possible band permutations [nchan x nfreqs x nfreqs x nobs x ntrials]
    baseline_bands: array
        same as `target_bands` [nchan x nfreqs x nfreqs x nobs x ntrials]
    """
    
    data_array_norm = target_stft_norm
    baseline_array_norm = baseline_stft_norm

    fmax = 500
    fidx = f < fmax
    fnum = f[fidx].size

    band_tot = np.zeros((fnum, fnum, data_array_norm.shape[0], data_array_norm.shape[2], data_array_norm.shape[3]))
    band_tot_bl = np.zeros((fnum, fnum, baseline_array_norm.shape[0], baseline_array_norm.shape[2], baseline_array_norm.shape[3]))
    for i in range(fnum):
        for j in range(fnum):
            if j > i:
                idx = (f >= f[i]) & (f < f[j])
                band_tot[i, j, :, :] = np.sum(data_array_norm[:, idx, :, :], axis=1) / (f[j] - f[i])
                band_tot_bl[i, j, :, :] = np.sum(baseline_array_norm[:, idx, :, :], axis=1) / (f[j] - f[i])


    band_tot_bl1 = np.mean(band_tot_bl, axis=3)     # average across time bins
    band_tot_bl2 = np.repeat(band_tot_bl1[:, :, :, None, :], band_tot_bl.shape[3], axis=3)    # repeat same value across time
    return band_tot, band_tot_bl2

def get_snr(target, baseline):
    """
    Returns the SNR given two vectors: target and baseline.
    
    Parameters
    ----------
    target: array [nchan x nfreqs x nfreqs x nobs x ntrials]
        an array obtained by using `get_bands()`
    
    baseline: array (same as target)

    Returns
    -------
    snr: array [nfreqs x nfreqs]
        a lower triangular matix representing the contrast between bands
    """

    mu_cue = np.mean(target, axis=-1)     # average accross trials
    mu_bl = np.mean(baseline, axis=-1)     # average accross trials
    std_cue = np.std(target, axis=-1)     # average accross trials
    std_bl = np.std(baseline, axis=-1)     # average accross trials

    snr = np.abs(_div0((mu_cue - mu_bl), (std_cue + std_bl)))
    snr2 = np.nanmax(snr, axis=-1)
    if snr2.shape[0] == snr.shape[1]:
        snr2 = np.nanmax(snr2, axis=-1)

    return snr2

def _div0( a, b ):
    """ignore / 0, div0( [-1, 0, 1], 0 ) -> [0, 0, 0] """
    with np.errstate(divide='ignore', invalid='ignore'):
        c = np.true_divide( a, b )
        c[ ~ np.isfinite( c )] = 0  # -inf inf NaN
    return c

def generate_ts(nsamples=10000, fs=1000, **kwargs):
    """
    Generates a 10s long LFP-like timeseries at 1kHz obeying the power law.
    """
    # For unit test
    if 'seed' in kwargs.items(): np.random.seed=kwargs['seed']
   
    # Generate some pink noise
    t = np.arange(nsamples) # timesteps
    f = 2*np.pi*t/fs  # frequency (in radians)

    # generate random complex series
    n = np.zeros((nsamples,), dtype=complex)
    n = np.exp(1j*np.random.uniform(0, 2*np.pi, (nsamples, )))

    # make frequency follow 1/f law
    n[1:] = np.array(n[1:])/f[1:]

    # Add some LFP-like components
    #=== TO DO ===#

    # generate the timeseries
    s = np.real(np.fft.ifft(n))
    return s

def simulate_recording(nchans=10, nsamples=10000, fs=1000, **kwargs):
    """
    Simulates an LFP recording with bursts in power of certain bands.
    """

    # create empty array
    dat = np.zeros((nchans, nsamples))

    # fill array with pink noise
    for i in range(dat.shape[0]):
        dat[i,:] = generate_ts(seed=42)
    
    dat = np.repeat(dat[:, :, np.newaxis], 10, axis=-1)

    return dat
 
def test():
    """
    Simple test method to ensure that the pipeline and dependencies work.
    
    Returns `True` if everything works.
    """
    s = simulate_recording(seed=42)
    norm = get_norm_array(s)
    ds, f = get_stft(s, norm_array=norm)
    t, b = get_bands(ds[:,:,:,:2], ds[:,:,:,-2:], f)
    snr = get_snr(t, b)
    
    print(np.int(snr.ravel().max())==0)
    
def contrast(data, y, **kwargs):
    """
    This method returns the SNR given a data array and vector of labels.
    
    Ideally, this should be the only method that you need to call when contrasting timeseries' spectra.
    
    Parameters
    ----------
    data: array [nchans x nobs x ntrials]
        an array with the LFP data organized into channels and trials.
    y: array [ntrials]
        a binary vector with a label for each trial being either 0 or 1
        
    Returns
    -------
    snr: array [nfreqs x nfreqs]
        a matrix with the SNR for each combination of frequency bands
    f: array [nfreqs]
        a vector that represents the frequencies for interpreting `snr`.
    """
    
    # read stft params from function arguments
    if 'fs' in kwargs.items(): fs=kwargs['fs']
    else: fs = 1000

    if 'nperseg' in kwargs.items(): noverlap=kwargs['nperseg']
    else: nperseg = 640

    if 'noverlap' in kwargs.items(): noverlap=kwargs['noverlap']
    else: noverlap = 3*(nperseg//4)
    
    # convert input to numpy array (precautionarily)
    data = np.array(data)    
    
    # get normalization array
    norm = get_norm_array(data)
    
    # decompose data
    ds, f = get_stft(data, norm_array=norm)
    
    # compute mean power over every permutation of bands
    t, b = get_bands(ds[:,:,:,y==1], ds[:,:,:,y==0], f)
    
    # calculate the snr
    snr = get_snr(t, b)
    
    return snr, f

def filter(data, low_pass, high_pass, fs, order=10):
    """
    Generates an n-th order butterworth filter and performs forward-backward pass on the signal.
    
    Parameters
    ----------
    data: array
        same as data structure [nchans x nobs x ntrials]
    low_pass: param
        low pass frequency
    high_pass: param
        high pass frequency
    fs: param
        sampling frequency
    order: param
        filter order
        
    Returns
    -------
    filt_data: array
        array with same shape as `data` but bandpass filtered
    """

    nyq = fs/2
    low = low_pass/nyq
    high = high_pass/nyq

    b, a = signal.butter(order, [low, high], btype='band')
    filt_data = np.abs(signal.hilbert(signal.filtfilt(b, a, data, axis=1), axis=1))
    return filt_data

if __name__ == '__main__':
    test()