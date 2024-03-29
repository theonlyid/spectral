"""
Module for contrasting timeseries data based on their spectral properties.

The set of methods are aimed at finding the frequency bands that enable the maximal seperability betwen two sets of timeseries data.
"""

# IMPORT DEPENDENCIES

from __future__ import absolute_import, print_function
import numpy as np
from scipy import signal
from spectral.data_handling import Dataset, TsParams, DataArray

# Code starts here
def contrast(ds: Dataset, y: list, debug=False, **kwargs):
    """
    This method returns the SNR given a data array and vector of labels.
    
    Ideally, this should be the only method that you need to call when contrasting timeseries' spectra.
    
    Parameters
    ----------
    ds: Dataset object
        an instance of `spectral.data_handling.Dataset` containing LFP data and relevant parameters for signal processing.
    y: list [ntrials]
        a binary vector with a label for each trial being either 0 or 1
        
    debug: param (bool)
        Flag for printing debugging output
        
    Returns
    -------
    snr: array [nfreqs x nfreqs]
        a matrix with the SNR for each combination of frequency bands starting from lowest frequency in f to the highest.
        The first axis represents the start band the second axis represents the stop band.
    f: array [nfreqs]
        a vector that represents the frequencies for interpreting `snr`.
    """

    # Read params from the Dataset passed to the method
    fs, nperseg, noverlap = ds.data_array.fs, ds.params.nperseg, ds.params.noverlap

    y = np.array(y)

    # convert input to numpy array (precautionarily)
    data = ds.data_array.data

    # get normalization array
    if debug:
        print("Obtain normalization array...")
    norm = get_norm_array(data, fs=fs, nperseg=nperseg, noverlap=noverlap)

    # decompose data
    if debug:
        print("calculating stft...")
    ds, f = get_stft(
        data, norm_array=norm, normalize=True, fs=fs, nperseg=nperseg, noverlap=noverlap
    )

    # compute mean power over every permutation of bands
    if debug:
        print("normalizing matrices... this may take a few minutes...")
    t, b = get_bands(ds[:, :, :, y == 1], ds[:, :, :, y == 0], f, **kwargs)

    # calculate the snr
    if debug:
        print("obtaining snr...")
    snr = get_snr(t, b)

    # Return the correct vector f
    fmin = int(kwargs["fmin"]) if "fmin" in kwargs else min(f)
    fmax = int(kwargs["fmax"]) if "fmax" in kwargs else max(f)
    fidx = [i for i in range(len(f)) if f[i] >= fmin and f[i] <= fmax]
    f = f[fidx]

    return snr, f


def get_norm_array(data: np.ndarray, fs=100, nperseg=64, noverlap=48, **kwargs):
    """
    Returns the normalization array for timeseries data.
    
    Parameters
    ----------
    data: array, timeseries data [nchan x nobs x ntrials]
    fs: int, sampling frequency in Hz
    nperseg: int, number of timepoints for stft window
    noverlap: int, number of timepoints for window overlap

    Returns
    -------
    norm_array: normalized array with mean power per frequency [nchan x freqs]
    """

    # Get the STFT of the signals
    f, _, data_stft = signal.stft(
        data, fs=fs, nperseg=nperseg, noverlap=noverlap, axis=1
    )

    data_stft = np.moveaxis(np.abs(data_stft), 2, 3)  # last axis is now ntrials
    data_stft = data_stft[:, :, 1:-1, :]  # purge STFT flanks

    # Average across trials and time-bins
    data_stft_mean = np.mean(np.abs(data_stft), axis=-1)  # trials
    norm_array = np.mean(np.abs(data_stft_mean), axis=-1)  # timebins

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
    if "fs" in kwargs:
        fs = int(kwargs["fs"])
    else:
        fs = 100

    if "nperseg" in kwargs:
        nperseg = int(kwargs["nperseg"])
    else:
        nperseg = 64

    if "noverlap" in kwargs:
        noverlap = int(kwargs["noverlap"])
    else:
        noverlap = 3 * (nperseg // 4)

    # Calculate the short-time fourrier transform
    f, _, data_stft = signal.stft(
        data_array,
        fs=fs,
        nperseg=nperseg,
        noverlap=noverlap,
        axis=1,
        detrend="constant",
    )

    # Make last axis as trials
    data_stft = np.moveaxis(np.abs(data_stft), 2, 3)
    data_stft = data_stft[:, :, 1:-1, :]

    if normalize:
        # Facilitate vectorized division
        norm_array_data = np.repeat(
            norm_array[:, :, np.newaxis], data_stft.shape[-2], axis=-1
        )
        norm_array_data = np.repeat(
            norm_array_data[:, :, :, np.newaxis], data_stft.shape[-1], axis=-1
        )

        # Normalize the spectrograms for calculating SNR
        data_stft_norm = data_stft / norm_array_data

        return data_stft_norm, f

    else:
        return data_stft, f


def get_bands(target_stft_norm, baseline_stft_norm, f, **kwargs):
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

    fmin = int(kwargs["fmin"]) if "fmin" in kwargs else min(f)
    fmax = int(kwargs["fmax"]) if "fmax" in kwargs else max(f)
    fidx = [i for i in range(len(f)) if f[i] >= fmin and f[i] <= fmax]
    f = f[fidx]
    fnum = len(f)

    data_array_norm = np.array(target_stft_norm[:, fidx, :, :])
    baseline_array_norm = np.array(baseline_stft_norm[:, fidx, :, :])

    band_tot = np.empty(
        (
            fnum,
            fnum,
            data_array_norm.shape[0],
            data_array_norm.shape[2],
            data_array_norm.shape[3],
        )
    )
    band_tot_bl = np.empty(
        (
            fnum,
            fnum,
            baseline_array_norm.shape[0],
            baseline_array_norm.shape[2],
            baseline_array_norm.shape[3],
        )
    )

    band_tot[:] = np.nan
    band_tot_bl[:] = np.nan

    for i in range(fnum):
        for j in range(fnum):
            if j > i:
                idx = (f >= f[i]) & (f < f[j])

                band_tot[i, j, :, :] = np.sum(data_array_norm[:, idx, :, :], axis=1) / (
                    f[j] - f[i]
                )
                band_tot_bl[i, j, :, :] = np.sum(
                    baseline_array_norm[:, idx, :, :], axis=1
                ) / (f[j] - f[i])

    band_tot_bl1 = np.mean(band_tot_bl, axis=3)  # average across time bins
    band_tot_bl2 = np.repeat(
        band_tot_bl1[:, :, :, None, :], band_tot_bl.shape[3], axis=3
    )  # repeat same value across time
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

    mu_cue = np.mean(target, axis=-1)  # average accross trials
    mu_bl = np.mean(baseline, axis=-1)  # average accross trials
    std_cue = np.std(target, axis=-1)  # average accross trials
    std_bl = np.std(baseline, axis=-1)  # average accross trials

    snr = np.abs(_div0((mu_cue - mu_bl), (std_cue + std_bl)))
    snr2 = np.nanmax(snr, axis=-1)
    if snr2.shape[0] == snr.shape[1]:
        snr2 = np.nanmax(snr2, axis=-1)

    return snr2


def _div0(a, b):
    """ignore / 0, div0( [-1, 0, 1], 0 ) -> [0, 0, 0] """
    with np.errstate(divide="ignore", invalid="ignore"):
        c = np.true_divide(a, b)
        c[~np.isfinite(c)] = 0  # -inf inf NaN
    return c


def decimate(x, n, **kwargs):
    """
    Downsample the data in a data array by a factor of n.
    
    Parameters
    ----------
    x: data array [nchan x nobs x ntrials]
        the data array to be analyzed.
    
    n: int
        the downsampling factor

    Returns
    -------
    data_dec: array [nchan x nobs/n x ntrials]
        downsampled array
    """

    data_dec = signal.decimate(x, n, axis=1)
    return data_dec


def __get_f_from_idx(idx, f):
    """
    Returns the value of f from the index
    
    Parameters
    ----------
    
    idx: array 
        array with indices for which frequencies are required
        
    Returns
    -------
    f: array
        array with frequencies corresponding to idx
    
    """

    return [f[i] for i in idx]


def test():
    """
    Simple test method to ensure that the pipeline and dependencies work.
    
    Returns `True` if everything works.
    """
    params = TsParams(nperseg=64, noverlap=48)
    da = DataArray(fs=1000, nchannels=10, ntrials=10, simulate=True)
    ds = Dataset(da, params)

    ds.data_array.data = decimate(ds.data_array.data, 10)

    y = np.ones((ds.data_array.data.shape[-1]))
    y[2:] = 0

    snr, _ = contrast(ds, y, fs=100, nperseg=64, noverlap=48)
    snr2, _ = contrast(ds, y)

    return np.allclose(snr, snr2)


def filter(data, low_pass, high_pass, fs, order=4):
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

    nyq = fs / 2
    low = low_pass / nyq
    high = high_pass / nyq
    b, a = signal.butter(order, [low, high], btype="band")
    filt_data = signal.filtfilt(b, a, data, axis=1, method="gust")
    return filt_data


if __name__ == "__main__":
    test()
