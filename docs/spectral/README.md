# Spectral

Python module for clustering, contrasting and classifying neural time-series frequencies between various brain-states.

## Get up and running

The package uses python/cython as a computation backend, and makes the methods and variables MATLAB compatible.

**!! WARNING: These instructions are only valid for 64-bit Windows systems with Python 3.7 !!**

**Make sure you have [Anaconda 3.7](https://docs.anaconda.com/anaconda/packages/py3.7_win-64/) and [Matlab R2019b](http://www.mathworks.com/) installed**

<font color="red">*In case you don't have Anaconda 3.7 Installed, or haven't called python code from Matlab before, see instructions for setting up Python 3.7 with Matlab 2019b in the main Readme located in the project root folder or the repository [homepage](https://www.github.com/theonlyid/spectral).*</font>

**Setup Instructions:**

1. Clone/checkout this branch into a local folder and double click on **"Launch Matlab.bat"** in the root folder. This is critical otherwise Matlab will be blind to the Python interpreter.

2. Test if python dependencies work: Type ```py.help("numpy")```. It should return a list of numpy methods. If not, see the installation instructions in the main README file.

3. Run the test method (see code snippet below). It should return True. This means everything works. Make sure you are in the root folder.

```java
>> sc = py.importlib.import_module("src.spectral.contrast");
>> sc.test()
True
```

### Examples

There are example notebooks, for Python and Matlab, that reside in [/docs/spectral/notebooks/](/docs/spectral/notebooks/). Refer to these if you are a first time user, they have example code and breif explanations on why certain methods are called the way they are.

### Documentation

There are two formats for documentation, html and pdf.

The PDF version is for very quick reference online (while browsing the repository). It can be accessed [here](docs/spectral/documentation.pdf).

After the repo has been cloned to a local folder, using the [HTML version](/docs/spectral/html/index.html) is recommended, which is much more verbose.

After cloning, refer to the [Getting Started](/docs/Getting\ Started.md) page.
