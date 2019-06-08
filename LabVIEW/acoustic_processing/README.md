# acoustic_processing

This repository is aimed at making the acoustic localisation system work for Anahita.

Steps to compile the code presently:

1. Install fftw from their website. Then try to make.
2. Unusual linting bug in Eigen Vectors library. I don't know how relevant it is to us. But I fixed it and moved on.

### Current status of the code:

If we input two pinger angles, then the `main.cpp` program creates two signals corresponding to a sine wave and a specified phase angles. This is further fed to `music.cpp` which finds the correct angle by plotting all possible angles and finding the one with the least phase. (Read the paper on MUSIC, pretty easy to understand then).