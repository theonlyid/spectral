# Spectral Contrasting: answers to the what and how

Author: Ali Zaidi

## Overview

Our primary motivation is to identify events in neural time-series. Specifically, we're interested in contrasting time-series data, ie, given the time-series of two "conditions", we woud like to identify frequency bands that are most different.

## Preparing the data

The code supports contrasting between two conditions. The way to organize the arrays is to create tensors with the following structure: nchans x timepoints x trials.

**Ideally, keeping the number of timepoints equivalent to the sampling frequency is advised, though not a requirement. It enables faster computation.**

Before starting, ensure you're in the repo's root folder and that the module has been imported properly.

For python:

```python
import src.spectral.contrast as sc
```

for Matlab:

```matlab
sc = py.importlib.import_module("src.spectral.contrast");
```

We begin by a single data array, that has the structure of nchans x timepoints x trials. Each trial consists of a regular window (default is 1 second), which is classified as either target or baseline.

## An overview of the contrasting algorithm

To begin with, we obtain a normalization vector for the entire dataset. This helps in normalizing the frequency spectrum across our two conditions, enabling better contrasting.

```python
norm = sc.get_norm_array(data, fs=1000, nperseg=64, noverlap=48)
```

This step performs a STFT on the data, and obtains the average power per frequency per channel. So the shape of norm is nchan x freqs.

The data is then separated into a baseline and target array, inherting the same structure as the original dataset. Imagine a binary variable **y** that keeps track of trial labels, taking a value of 0 if they beling to the baseline, and 1 if they belong to the target category.

```python
target = data[:,:,:, y=1]
baseline = data[:,:,:, y=0]
```

We then perform a short-time frequency transform of the data, and normalize the frequencies of both arrays.

```python
targ_stft, f = sc.get_stft(target, norm_array=norm)
base_stft, f = sc.get_stft(baseline, norm_array=norm)
```

The critical step is constructing a matrix that contains the mean power over all possible combinations of frequency bands, for each channel.

```python
t, b = sc.get_bands(targ_stft, base_stft, f)
```

The last step is obtaining the contrast between the baseline and target arrays.

```python
snr = sc.get_snr(t, b)

# for plotting using matplotlib
plt.imshow(snr, origin='bottom', interpolation='bicubic')
```

### How to read the SNR matrix

The SNR matrix is two dimensional. For each entry, the first axis represents the band start, and the second represents the band stop. This allows a handle into the start and stop bands that enable maximal seperation of the two signals. Eg, the maximal separation indices could be (4, 8), where 4 is the band start and 8 is the band stop. To get the frequencies for the respective indices, use the **f** vector (f[4]).

### Using the SNR matrix

After obtaining the bands where the SNR is maximum, the final step is to filter the data within those frequency bands:

```python
filt_data = sc.filter(data, bandstart, bandstop, fs)
```

This will return a matrix with the shape of the original data but band-pass filtered within the frequency range desirable for further analysis.

## Appendix

### Appendix 1: Mathematical background

#### 1.1 Spectral Contrasting

<--> Under Constuction <-->

<!-- We're interested in contrasting the frequencies across two timeseries.

$$ \bm{X_{k, r} (m,\omega)  = \sum_{ -\infty }^{ \infty } \bm{x_{k, r}}[n] \bm{w} [n - m]e^{-j \omega n}} $$

We then compute the mean power across all frequencies

$$ \bm{Y_{k}}[f] = \frac{1}{N} \frac{1}{r} \sum_{1}^{N}\bm{X_{k}}[f] $$

$$ X_{norm}^{-1} X^T $$

$$ \bm{\frac{\left\Vert \bm{\mu}_{targ} - \bm{\mu}_{base} \right\Vert}{\bm{\sigma}^2_{targ}+\bm{\sigma}^2_{base}}} $$ -->
