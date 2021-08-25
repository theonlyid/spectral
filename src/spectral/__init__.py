"""
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
    This module provides code to train classifiers for classifying timeseries data based on the clusters identified using the `spectral.cluster` module.

Author: Ali Zaidi

Version 0.1
"""

from . import contrast, classify, cluster, data_handling
