---
description: |
    API documentation for modules: spectral, spectral.classify, spectral.cluster, spectral.contrast, spectral.test_contrast.

lang: en

classoption: oneside
geometry: margin=1in
papersize: a4

linkcolor: blue
links-as-notes: true
...


    
# Module `spectral` {#spectral}

Spectral

A library for analysing timeseries data, specifically for neural event identification, detection and classification.

Consists of three submodules, which can be used either independently or together:

1. Contrast:
    This module enables the contrasting between two categories of timeseries data (with multiple trials per category).
    This enables the identification of the frequency bins that have the most differnce between the categories.

2. Cluster:
    This module enables the clustering of the timeseries data based on the similarity of it's spectral decomposition using STFT.
    It finds the optimal number of clusters and returns a vector with labels of which class each STFT segment belongs to.
    
3. Classify:
    This module provides code to train classifiers for classifying timeseries data based on the clusters identified using the <code>[spectral.cluster](#spectral.cluster "spectral.cluster")</code> module.

Author: Ali Zaidi

Version 0.1


    
## Sub-modules

* [spectral.classify](#spectral.classify)
* [spectral.cluster](#spectral.cluster)
* [spectral.contrast](#spectral.contrast)
* [spectral.test_contrast](#spectral.test_contrast)






    
# Module `spectral.classify` {#spectral.classify}

Module for classifying timeseries data based on their spectral properties.

This module enables the classification of STFT transformed data
by training an SVM classifier.

This facilitates the identification of various events (defined as transient spatio-temporal patterns of activity)
present within the timeseries data, that have been identified.




    
## Functions


    
### Function `classifySVM` {#spectral.classify.classifySVM}




>     def classifySVM(
>         self,
>         X,
>         y
>     )


Trains an SVM-classifier on the data.

###### Parameters

**```X```** :&ensp;<code>array</code>
:   Training data with shape: nobs x features


**```y```** :&ensp;<code>array</code>
:   vector with training labels

###### Returns

**```scores```** :&ensp;<code>array</code>
:   a vector of scores with length equal to number of CV-folds


**```clf```** :&ensp;<code>python object</code>
:   the trained classifier as a python object



    
### Function `generate_features` {#spectral.classify.generate_features}




>     def generate_features(
>         data,
>         labels,
>         **kwargs
>     )


Generate a feature vector for training a classifier

###### Parameters

**```data```** :&ensp;<code>array</code>
:   array with structure


**```labels```** :&ensp;<code>array</code>
:   vector with class labels

###### Returns

**```X```** :&ensp;<code>array</code>
:   an array with the features in the 1st axis and trials on the 0-th axis


**```y```** :&ensp;<code>array</code>
:   a vector with the same number of rows as X containing class labels






    
# Module `spectral.cluster` {#spectral.cluster}

Module for clustering timeseries data based on their spectral properties.

This module enables the clustering of STFT transformed data
by mapping the STFT arrays to a low dimensional manifold and then clustering them using DBSCAN.

This facilitates the identification of various events (defined as transient spatio-temporal patterns of activity) present within the timeseries data.




    
## Functions


    
### Function `cluster` {#spectral.cluster.cluster}




>     def cluster(
>         data,
>         **kwargs
>     )


Clusters the array using OPTICS and dbscan. Finds the best number of clusters.

###### Parameters

**```data_array```** :&ensp;<code>array</code>
:   STFT array or low-dimensional embedding from <code>[embed()](#spectral.cluster.embed "spectral.cluster.embed")</code> [nchan x nobs x ntrials]

###### Returns

**```res```** :&ensp;<code>array</code>
:   results with res[0] having the


**```nclust```** :&ensp;<code>int</code>
:   number of clusters identified



    
### Function `embed` {#spectral.cluster.embed}




>     def embed(
>         data_stft_norm,
>         **kwargs
>     )


Returns a low-dimensional embedding of an STFT array.

###### Parameters

**```data_norm```** :&ensp;<code>array</code>
:   normalized stft array [nchan x nfreqs x nobs x ntrials]


   
###### Returns

**```embedding```** :&ensp;<code>array</code>
:   low dimensional embedding of the STFT array



    
### Function `stft_norm` {#spectral.cluster.stft_norm}




>     def stft_norm(
>         data,
>         **kwargs
>     )


Returns the frequency-normalized STFT for timeseries data.

###### Parameters

**```data_array```** :&ensp;<code>array</code>
:   timeseries data [nchan x nobs x ntrials]


**```*fs```** :&ensp;<code>int</code>
:   sampling frequency in Hz


**```*nperseg```** :&ensp;<code>int</code>
:   number of timepoints for stft window


**```*noverlap```** :&ensp;<code>int</code>
:   number of timepoints for window overlap

###### Returns

**```stft_norm```** :&ensp;<code>array</code>
:   STFT of the input array [nchan x nfreqs x nobs x trials]


**```f```** :&ensp;<code>array</code>
:   an array of the frequencies of the STFT transform






    
# Module `spectral.contrast` {#spectral.contrast}

Module for contrasting timeseries data based on their spectral properties.

The set of methods are aimed at finding the frequency bands that enable the maximal seperability betwen two sets of timeseries data.




    
## Functions


    
### Function `contrast` {#spectral.contrast.contrast}




>     def contrast(
>         data,
>         y,
>         **kwargs
>     )


This method returns the SNR given a data array and vector of labels.

Ideally, this should be the only method that you need to call when contrasting timeseries' spectra.

###### Parameters

**```data```** :&ensp;<code>array \[nchans x nobs x ntrials]</code>
:   an array with the LFP data organized into channels and trials.


**```y```** :&ensp;<code>array \[ntrials]</code>
:   a binary vector with a label for each trial being either 0 or 1


**```**fs```** :&ensp;<code>int</code>
:   the sampling frequency of the signal


**```**nperseg```** :&ensp;<code>param (int)</code>
:   number of samples per fft


**```**noverlap```** :&ensp;<code>param (int)</code>
:   number of samples of overlap between successive ffts

###### Returns

**```snr```** :&ensp;<code>array \[nfreqs x nfreqs]</code>
:   a matrix with the SNR for each combination of frequency bands


**```f```** :&ensp;<code>array \[nfreqs]</code>
:   a vector that represents the frequencies for interpreting <code>snr</code>.



    
### Function `filter` {#spectral.contrast.filter}




>     def filter(
>         data,
>         low_pass,
>         high_pass,
>         fs,
>         order=4
>     )


Generates an n-th order butterworth filter and performs forward-backward pass on the signal.

###### Parameters

**```data```** :&ensp;<code>array</code>
:   same as data structure [nchans x nobs x ntrials]


**```low_pass```** :&ensp;<code>param</code>
:   low pass frequency


**```high_pass```** :&ensp;<code>param</code>
:   high pass frequency


**```fs```** :&ensp;<code>param</code>
:   sampling frequency


**```order```** :&ensp;<code>param</code>
:   filter order

###### Returns

**```filt_data```** :&ensp;<code>array</code>
:   array with same shape as <code>data</code> but bandpass filtered



    
### Function `generate_ts` {#spectral.contrast.generate_ts}




>     def generate_ts(
>         nsamples,
>         fs,
>         **kwargs
>     )


Generates an LFP-like timeseries sampled at fs obeying the power law.

    
### Function `get_bands` {#spectral.contrast.get_bands}




>     def get_bands(
>         target_stft_norm,
>         baseline_stft_norm,
>         f
>     )


Calculates the mean power across all possible combinations of frequencies for each channel.

###### Parameters

**```target_stft_norm```** :&ensp;<code>array</code>
:   stft decomposed target array [nchan x nfreqs x nobs x ntrials]


**```baseline_stft_norm```** :&ensp;<code>array</code>
:   stft decomposed baseline array [nchan x nfreqs x nobs x ntrials]


**```f```** :&ensp;<code>array</code>
:   vector of frequencies obtained from STFT transform (see <code>[get\_stft()](#spectral.contrast.get\_stft "spectral.contrast.get\_stft")</code>).

###### Returns

**```target_bands```** :&ensp;<code>array</code>
:   array of mean power across all possible band permutations [nchan x nfreqs x nfreqs x nobs x ntrials]


**```baseline_bands```** :&ensp;<code>array</code>
:   same as <code>target\_bands</code> [nchan x nfreqs x nfreqs x nobs x ntrials]



    
### Function `get_norm_array` {#spectral.contrast.get_norm_array}




>     def get_norm_array(
>         data,
>         **kwargs
>     )


Returns the normalization array for timeseries data.

###### Parameters

**```data```** :&ensp;<code>array, timeseries data \[nchan x nobs x ntrials]</code>
:   &nbsp;


**```**fs```** :&ensp;<code>int, sampling frequency in Hz</code>
:   &nbsp;


**```**nperseg```** :&ensp;<code>int, number</code> of <code>timepoints for stft window</code>
:   &nbsp;


**```**noverlap```** :&ensp;<code>int, number</code> of <code>timepoints for window overlap</code>
:   &nbsp;

###### Returns

**```norm_array```** :&ensp;<code>normalized array with mean power per frequency \[nchan x freqs]</code>
:   &nbsp;



    
### Function `get_snr` {#spectral.contrast.get_snr}




>     def get_snr(
>         target,
>         baseline
>     )


Returns the SNR given two vectors: target and baseline.

###### Parameters

**```target```** :&ensp;<code>array \[nchan x nfreqs x nfreqs x nobs x ntrials]</code>
:   an array obtained by using <code>[get\_bands()](#spectral.contrast.get\_bands "spectral.contrast.get\_bands")</code>


**```baseline```** :&ensp;<code>array (same as target)</code>
:   &nbsp;

###### Returns

**```snr```** :&ensp;<code>array \[nfreqs x nfreqs]</code>
:   a lower triangular matix representing the contrast between bands



    
### Function `get_stft` {#spectral.contrast.get_stft}




>     def get_stft(
>         data_array,
>         norm_array=[],
>         normalize=True,
>         **kwargs
>     )


Returns the STFT for timeseries data.

###### Parameters

**```data_array```** :&ensp;<code>array</code>
:   timeseries data [nchan x nobs x ntrials]


**```norm_array```** :&ensp;<code>array</code>
:   for spectral normalization (see <code>[get\_norm\_array()](#spectral.contrast.get\_norm\_array "spectral.contrast.get\_norm\_array")</code>)


**```*fs```** :&ensp;<code>int</code>
:   sampling frequency in Hz


**```*nperseg```** :&ensp;<code>int</code>
:   number of timepoints for stft window


**```*noverlap```** :&ensp;<code>int</code>
:   number of timepoints for window overlap

###### Returns

**```stft_array```** :&ensp;<code>array</code>
:   STFT of the input array [nchan x nfreqs x nobs x trials]


**```f```** :&ensp;<code>array</code>
:   an array of the frequencies of the STFT transform



    
### Function `simulate_recording` {#spectral.contrast.simulate_recording}




>     def simulate_recording(
>         **kwargs
>     )


Simulates an LFP recording with bursts in power of certain bands.

    
### Function `test` {#spectral.contrast.test}




>     def test()


Simple test method to ensure that the pipeline and dependencies work.

Returns <code>True</code> if everything works.




    
# Module `spectral.test_contrast` {#spectral.test_contrast}






    
## Functions


    
### Function `test_contrast` {#spectral.test_contrast.test_contrast}




>     def test_contrast()






-----
Generated by *pdoc* 0.8.4 (<https://pdoc3.github.io>).
