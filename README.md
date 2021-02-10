[![Build Status](https://travis-ci.com/theonlyid/spectral.svg?branch=master)](https://travis-ci.com/theonlyid/spectral)
[![codecov](https://codecov.io/gh/theonlyid/spectral/branch/master/graph/badge.svg?token=0Y4MS7INZV)](https://codecov.io/gh/theonlyid/spectral)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

# Spectral: a toolbox for neural timeseries analysis

## Table of contents

1. [The What](#what): about this repository and code

    1.1 [Current Modules](#modules): a list of modules

2. [The Where](#where): folder organisation and structure

3. [The How](#how): installation, execution

    3.1 [Installation and setup](#install)

    3.2 [Using the modules](#usemodules)

4. [Documentation](#docs)

5. [FAQS](#faqs)

________

## 1. The What <a name='what'></a>

Contains Matlab and Python scripts for Spectral, a toolbox for neural timeseries analysis developed at MPIBK AG Logothetis. The toolbox enables clustering, contrasting and classification of timeseries based on their spectral properties. It consits of submodules with code for performing each of those steps.

### 1.1 Current modules <a name='currentmodules'></a>

**[Spectral](/docs/spectral/README.md) mainained by Ali**

## 2. The Where <a name='where'></a>

The root directory has two subdirs: src and docs.

**src** houses all source-code. It has an [about.md](/docs/about.md) file on how to add and maintain sourcecode

**docs** houses all documentation. Each module has its own sub-directory.

## 3. The How <a name='how'></a>

### 3.1 Installation and setup <a name='install'></a>

#### Installing Anaconda <a name='installanaconda'></a>

Install [Anaconda version 3.7](https://docs.anaconda.com/anaconda/packages/py3.7_win-64/) by clicking the link and following the default setup instructions.

#### Installing the module spectral

Install the package using:

```bash
$python setup.py install
```

#### Calling Python from Matlab <a name="callpython"></a>

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

### Adding untracked local files and folders <a name="custom"></a>

You can add your own scripts or notebooks to folders, or your own folders to the repo, and make sure they aren't tracked.
This will ensure you do not add them to the repository, or lose them if you pull a new version/release.

#### Files

Add the prefix "temp_" or "tmp_" (e.g. temp_analysis.m) to your files. Any file with that prefix will be ignored.
Open [gitignore](.gitignore) for a complete list of files/folders ignored.

#### Folders

Ignoring an entire folder is very easy. Create a text document titled ".gitignore" and add the asterisk (*) symbol in the document and save it. This will ignore the entire folder. You can save data and custom scripts in such folders.

## 4. Documentation <a name="docs"></a>

The modules have documentation in HTML and PDF format in the docs folder. There are also example notebooks. The best way to access the documentation is by cloning the repo and opening the HTML documentation in docs/html/index.html.

For a quick overview of documentation while browsing the repo online, the PDF
version can be accessed from [docs/spectral/documentation.pdf](docs/documentation.pdf).

### Example notebooks

Post installation, a good place to start is example notebooks. They can be found in the docs, within the subfolder for each module.

For Spectral, the notebooks can be found [here](/docs/notebooks/).

## 5. FAQS <a name="faqs"></a>

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
    The contrasting algorithm converts the timeseries to frequency. It then loops over every combination of frequencies to find the snr. If you use a very high nobs, and a high nperseg, squaring that data will lead to memory issues. Try reducing the nperseg to 64 or even 32. This will reduce the frequency resolution, unfortunately.

##### This code is maintained by Ali Zaidi (azaidi(at)tue(dot)mpg(dot)de)
