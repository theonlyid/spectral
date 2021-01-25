# Spectral Contrasting for neural time-series analysis

Python module for contrasting neural time-series frequencies between various brain-states.

## Get up and running

The package uses python/cython as a computation backend, and makes the methods and variables MATLAB compatible.

**!! WARNING: These instructions are only valid for 64-bit Windows systems with Python 3.7 !!**

**Make sure you have [Anaconda 3.7](https://docs.anaconda.com/anaconda/packages/py3.7_win-64/) and [Matlab R2019b](http://www.mathworks.com/) installed**

<font color="red">*In case you don't have Anaconda 3.7 Installed, or haven't called python code from Matlab before, see instructions for setting up Python 3.7 with Matlab 2019b below in Appenndix A1.2*</font>

**Setup Instructions:**

1. Clone/checkout this branch into a local folder and double click on **"Launch Matlab.bat"** in the root folder. This is critical otherwise Matlab will be blind to the Python interpreter.

2. Test if python dependencies work: Type ```py.help("numpy")```. It should return a list of numpy methods. If not, see the Appendix section A2.1

3. Run the test method (see code snippet below). It should return True. This means everything works. Make sure you are in the root folder.

```matlab
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

## Appendix

### A1 Installation and setup

#### A1.1 Installing Anaconda

Install [Anaconda version 3.7](https://docs.anaconda.com/anaconda/packages/py3.7_win-64/) by clicking the link and following the default setup instructions.

#### A1.2 Adding Python dependencies to Matlab

Since Matlab needs to access python libraries, it is important to configure some paths. A template file (Matlab.bat.template) exists in root directory, which needs to be modified by updating two paths at lines 3 and 5.

1. From the Start Menu, launch the Anaconda Powershell prompt (Start Menu > Anaconda3 (64-bit) > Anaconda Powershell Prompt (anaconda3)).

2. Navigate to the NET-fMRI root directory. This is the directory where the contents of this repository reside.

3. Run ```python setup.py```. Wait for the prompt to confirm a 'Success!'. This should write a 'Matlab.bat' file in the current folder.

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

### A2 Common erros and exceptions

A list of the most common errors are below:

#### A2.1 Common exceptions and how to handle them

##### ```py.help('numpy')``` fails

This is caused when the python interpreter is not loaded by Matlab.
See appendix A1.2.

###### This code is maintained by [Ali Zaidi](mailto:ali.zaidi@tuebingen.mpg.de)
