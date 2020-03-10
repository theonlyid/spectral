## Branch: epics/spectralcontrasting

# Spectral Contrasting for LFP analysis

### What is this branch for?

For developing code to contrast LFP frequencies between various brain-states obtained from fMRI analysis.

### How do I get up and running?

The package uses python/cython as a computation backend, and makes the methods and variables MATLAB compatible. 

#### Make sure you have [Anaconda 3.7](https://docs.anaconda.com/anaconda/packages/py3.7_win-64/) and [Matlab R2019b](http://www.mathworks.com/) installed

!! WARNING: These instructions are only valid for 64-bit Windows systems with Python 3.7 !!

Setup Instructions:

1. Clone this repo and double click on **"Launch Matlab.bat"** in the home folder. This is critical otherwise Matlab will be blind to Python.

2. Test if python dependencies work: Type ```py.help("numpy")```. It should return a list of numpy methods.

3. Run the test method (see code snippet below). It should return True. This means everything works.

```matlab
>> sc = py.importlib.import_module("src.spectral.contrast");

>> sc.test()
True
```

If all this is a (miraculous) success, you can refer to the [documentation](/docs/index.html) and usage [summary](/docs/summary.md).

Good luck!

##### Branch maintained by [Ali Zaidi](mailto:ali.zaidi@tuebingen.mpg.de)
