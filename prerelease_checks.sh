#!/usr/bin/zsh

# This script is run before completing any major or minor release
# It runs pytest and updates the documentation

LOGFILE="logs/prelease_checks-`(date +%F)`.log"
touch $LOGFILE

echo "=================================================" >> $LOGFILE
echo "`date +%H:%M:%S`: Initiating Pre-release checks" >> $LOGFILE
echo "=================================================" >> $LOGFILE

source /home/zaidi/anaconda3/bin/activate >> $LOGFILE
conda activate spectral >> $LOGFILE
black . >> $LOGFILE
python setup.py install >> $LOGFILE
pytest >> $LOGFILE

echo "Compiling documentation...\n" >> $LOGFILE
pdoc -o ./docs/html/ --html src/spectral --force >> $LOGFILE

echo "Done!" >> $LOGFILE
echo "\n\n\n" >> $LOGFILE
