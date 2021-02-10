#!/usr/bin/env python

from distutils.core import setup

setup(
    name="spectral",
    version="0.5",
    description="Package for analysis of neural timeseries data",
    author="Greg Ward",
    author_email="gward@python.net",
    url="https://www.python.org/sigs/distutils-sig/",
    package_dir={"spectral": "src/spectral"},
    packages=["spectral"],
)
