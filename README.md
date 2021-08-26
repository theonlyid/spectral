[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![](https://img.shields.io/badge/Anaconda-3.7-blue)
![Version: 0.1](https://img.shields.io/badge/Version-0.1-green)
[![Build Status](https://travis-ci.com/theonlyid/spectral.svg?branch=master)](https://travis-ci.com/theonlyid/spectral)
[![codecov](https://codecov.io/gh/theonlyid/spectral/branch/master/graph/badge.svg?token=0Y4MS7INZV)](https://codecov.io/gh/theonlyid/spectral)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/theonlyid/spectral/master)

# Spectral: a toolbox for neural timeseries analysis (v0.1)

## Table of contents

1. [The What](#what): about this repository and code

    1.1 [Current Modules](#modules): a list of modules

2. [The Where](#where): folder organisation and structure

3. [Documentation](#docs)

4. [The How](#how): installation and use

    3.1 [Installation](#install)

    3.2 [Using the modules](#usemodules)

5. [Repository settings](#repo-settings)

6. [FAQS](#faqs)

________

## 1. The What <a name='what'></a>

Contains Matlab and Python scripts for Spectral, a toolbox for neural timeseries analysis developed at MPIBK AG Logothetis. The toolbox enables clustering, contrasting and classification of timeseries based on their spectral properties. It consits of submodules with code for performing each of those steps.

## 2. The Where <a name='where'></a>

The root directory has two subdirs: src and docs.

**src** houses all source-code for the module and submodules.

**docs** houses all documentation. Each module has its own sub-directory.

## 3. Documentation <a name="docs"></a>

The documentation exists in HTML in the docs folder. When browsing the repo online, the HTML documenation can be viewed online by using [Gihub's HTML Preview](https://htmlpreview.github.io/?https://github.com/theonlyid/spectral/blob/develop/docs/html/spectral/index.html).

There are also example notebooks in the docs folder. The best way to access the documentation is by cloning the repo and opening the HTML documentation in docs/html/index.html.

### Example notebooks

Post installation, a good place to start is example notebooks. They can be found in the docs, within the subfolder for each module. The notebooks can be found [here](/docs/notebooks/).

## 4. The How <a name='how'></a>

### 4.1 Installation and setup <a name='install'></a>

#### Installing Anaconda <a name='installanaconda'></a>

Install [Anaconda 3.7](https://docs.anaconda.com/anaconda/packages/py3.7_win-64/) by clicking the link and following the default setup instructions.

#### Installing Spectral

Install the package using setup.py:

```bash
$ python setup.py install

$ python
>> import spectral
```

*Note: in case you will use the module with Matlab,
it is advised to install the package in the base conda environment.

#### Using Spectral from Matlab <a name="callpython"></a>

Since Matlab needs to access python libraries, it is important to configure some paths.

1. From the Start Menu, launch the Anaconda Powershell prompt (Start Menu > Anaconda3 (64-bit) > Anaconda Powershell Prompt (anaconda3)).

2. Navigate to the root directory. This is the directory where the contents of this repository reside.

3. Run ```python setup_matlab.py```. Wait for the prompt to confirm a 'Success!'. This should write a 'Matlab.bat' file in the current folder.

4. Copy the statement above the last line of the installation prompt. It starts with ```pyversion```. This needs to be entered in Matlab, as described below.

Finally, Matlab's own python interpreter needs to be configured.

1. Close all current instances of Matlab, and launch a new instance by double clicking "Matlab.bat" in the root folder.

2. In the Matlab prompt paste the command you copied and press return. Type ```pyversion``` and press return. It should show something like:

   ```python
   >> pyversion

         version: '3.7'
      executable: 'C:\Users\Continuum\anaconda3\python.exe'
         library: 'C:\Users\Continuum\anaconda3\python37.dll'
            home: 'C:\Users\Continuum\anaconda3'
         isloaded: 0
   ```

3. Test python library loading using the command ```py.help("numpy")```.

### 3.2 Using the modules <a name="usemodules"></a>

Each python module can be used as an independent module or together with the full library. Depending on whether you are using matlab or python, the instructions are as follows:

#### Python

Start python and call:

```python
>> import spectral
```

or

```python
>> from spectral import contrast as sc
```

#### Matlab

Use the matlab.bat file in the project root folder to start Matlab.

From Matlab, import the necessary libraries:

```java
>> spectral = py.importlib.import_module("spectral")
```

You can then query the modules, submodules and all methods in the module
using py.help:

```java
>> py.help(spectral.contrast)
```

________

## Submodules in spectral

### 1. Contrast

#### Overview

Our primary motivation is to identify events in neural time-series. Specifically, we're interested in contrasting time-series data, ie, given the time-series of two "conditions", we woud like to identify frequency bands that are most different.

#### Preparing the data

The code supports contrasting between two conditions. The way to organize the arrays is to create tensors with the following structure: nchans x timepoints x trials.

**Ideally, keeping the number of timepoints equivalent to the sampling frequency is advised, though not a requirement. It enables faster computation.**

Before starting, ensure you're in the repo's root folder and that the module has been imported properly.

For python:

```python
from spectral import contrast as sc
```

for Matlab:

```matlab
sc = py.importlib.import_module("spectral.contrast");
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

________

## 5. Repository settings: Adding files and folders <a name="repo-settings"></a>

### Adding untracked local files and folders <a name="custom"></a>

You can add your own scripts or notebooks to folders, or your own folders to the repo, and make sure they aren't tracked. This will ensure you do not add them to the repository, or lose them if you pull a new version/release.

#### Ignored files

Add the prefix "temp_" or "tmp_" (e.g. temp_analysis.m) to your files. Any file with that prefix will be ignored.
Open [gitignore](.gitignore) for a complete list of files/folders ignored.

#### Ignored folders

Some folders are ignored by default, such as any folder titled "data". You can place your data files here without them being tracked and added to the repo.

Beyond this, ignoring an entire folder is very easy. Create a text document titled ".gitignore" and add the asterisk (*) symbol in the document and save it. This will ignore the entire folder. Any folders, files, etc in such folders will not be tracked.

## 6. FAQS <a name="faqs"></a>

1. What do I do if ```py.help('numpy')``` fails?

    This is caused when the python interpreter is not loaded by Matlab.

    1. Ensure Anaconda is installed.
    2. Make sure you close all instances of Matlab and start Matlab using the matlab.bat
    file in the repo's root folder.
    3. Ensure Matlab can access the python interpreter by calling ```pyversion```.

2. How do I add custom files or folders that I do not want tracked?
    Checkout the [instructions](#custom) above.

3. The contrast() function fails: Out of Memory Error

    Looks like you're crunching big numbers!
    The contrasting algorithm converts the timeseries to frequency. It then loops over every combination of frequencies to find the snr. If you use large ```nobs``` and ```nperseg```, squaring that data will lead to memory issues. Try reducing the nperseg to 64 or even 32. This will, however, reduce the frequency resolution.

##### This code is maintained by Ali Zaidi (azaidi [at] tue [dot] mpg [dot] de)
