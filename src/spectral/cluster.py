"""
Module for clustering timeseries data based on their spectral properties.

This module enables the clustering of STFT transformed data
by mapping the STFT arrays to a low dimensional manifold and then clustering them using DBSCAN.

This facilitates the identification of various events (defined as transient spatio-temporal patterns of activity) present within the timeseries data.
"""

from scipy.signal import stft
from umap import UMAP
import numpy as np
from sklearn.cluster import OPTICS, cluster_optics_dbscan
from sklearn.metrics import calinski_harabasz_score

def stft_norm(data, **kwargs):
    """
    Returns the frequency-normalized STFT for timeseries data.
    
    Parameters
    -----------
    data_array: array
        timeseries data [nchan x nobs x ntrials]
    *fs: int
        sampling frequency in Hz
    *nperseg: int
        number of timepoints for stft window
    *noverlap: int
        number of timepoints for window overlap
        
    Returns
    -------
    stft_norm: array
        STFT of the input array [nchan x nfreqs x nobs x trials]
    f: array
        an array of the frequencies of the STFT transform
    """
    
    nperseg=1024
    noverlap=3*nperseg//4

    f, t, data_stft = stft(data, fs=1000, nperseg=nperseg, noverlap=noverlap, axis=1)
    data_stft = np.abs(np.squeeze(data_stft)) # Required for normalization
    data_stft = data_stft[:200,10:-10]
    t = t[10:-10]
    f = f[:200]

    dsm = np.mean(data_stft, axis=1)
    dsm_r = np.repeat(dsm[:, np.newaxis], data_stft.shape[1], axis=1)

    dsd = np.std(data_stft, axis=1)
    dsd_r = np.repeat(dsd[:, np.newaxis], data_stft.shape[1], axis=1)

    data_stft_norm = data_stft / dsm_r

    dsm = np.mean(data_stft_norm, axis=(0,1))
    dsm_r = np.repeat(dsm, data_stft_norm.shape[0], axis=0)
    dsm_r = np.repeat(dsm_r[:, np.newaxis], data_stft_norm.shape[1], axis=1)

    dsd = np.std(data_stft_norm, axis=(0,1))
    dsd_r = np.repeat(dsd, data_stft_norm.shape[0], axis=0)
    dsd_r = np.repeat(dsd_r[:, np.newaxis], data_stft_norm.shape[1], axis=1)

    data_stft_norm = (data_stft_norm - dsm_r) / dsd_r
    data_stft_norm = data_stft_norm[:,10:-10]
    t = t[10:-10]
    
    return data_stft_norm, t

def embed(data_stft_norm, **kwargs):
    """
    Returns a low-dimensional embedding of an STFT array.
    
    Parameters
    -----------
    data_norm: array
        normalized stft array [nchan x nfreqs x nobs x ntrials]
       
    Returns
    -------
    embedding: array
        low dimensional embedding of the STFT array
    """
    
    manifold = UMAP(min_dist=0.0001)
    embedding = manifold.fit_transform(data_stft_norm.T)
    return embedding

def cluster(data, **kwargs):
    """
    Clusters the array using OPTICS and dbscan. Finds the best number of clusters.
    
    Parameters
    -----------
    data_array: array
        STFT array or low-dimensional embedding from `embed()` [nchan x nobs x ntrials]
        
    Returns
    -------
    res: array
        results with res[0] having the 
    nclust: int
        number of clusters identified
    """

    clust = OPTICS(min_samples=20, xi=.05, min_cluster_size=.1, n_jobs=-1)
    clust.fit(data)

    epsilon = np.arange(0, 2, step=.01)

    ncl = np.array([])
    res = np.array([])

    for e in epsilon:
        labels = cluster_optics_dbscan(reachability=clust.reachability_,
                                    core_distances=clust.core_distances_,
                                    ordering=clust.ordering_, eps=e)
        
        ncl = np.append(ncl, len(np.unique(labels[labels>-1])))
        if ncl[-1] <= 1:
            res = np.append(res, 0)
        else:
            res = np.append(res, calinski_harabasz_score(data, labels))

    nclust = np.unique(ncl)
    
    return res, nclust
