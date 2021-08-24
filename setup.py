#!/usr/bin/env python

from distutils.core import setup

setup(
    name="spectral",
    version="0.5",
    description="Package for analysis of neural timeseries data",
    author="Ali Zaidi",
    author_email="danishze@gmail.com",
    url="https://github.com/theonlyid/spectral",
    package_dir={"spectral": "src/spectral"},
    packages=["spectral"],
)
