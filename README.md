# NMRBiomed_Loubrie_setup

# README #


### What is this repository for? ###
This repository includes code to download input data, reconstruct, analyze, and generate figures for 

## MATLAB CODE
Requirements:
-------------
* MATLAB  - for reconstruction, processing, and figure generation
* gpuNUFFT 2.0.8 - find more information at https://github.com/andyschwarzl/gpuNUFFT 
* BruKitchen - compile this file to run the sequence, find more information at https://github.com/tesch1/BruKitchen

Tested Configuration:
---------------------
* Mac OS X 10511.5 (El Capitan)
* MATLAB R2015a
* Python 2.7.13

Installation Options:
---------------------
* Click the `Download ZIP` button on the lower right hand side of the repository to download the code to your local machine
* OR clone the git repository to your local machine
* OR fork to your own repository and then clone the git repository to your local machine

Data:
------


Usage:
------
* 1 - Download one or many dataset(s) and place them 
* 2 - Go to `./code/` and run `reco2seq.m` for T2 acquisitions of `Reco_LookLocker_Radial.m` for T1 acquisitions.
* 3 - Then use `T1mapping_LookLocker.m` for T1 mapping or `T2mapping_MSME.m` for T2 mapping. 

## 3D SETUP
`NMRBiomed_Loubrie_setup.FCStd` can be opened with open access software FreeCAD https://www.freecadweb.org/ 

## ARDUINO SEQUENCE SYNCHRONIZATION CODE
NMRBiomed_Loubrie_trigIRM.ino

Folder Structure:
--------
`./code/` - (with downloaded contributors) contains all code necessary to reconstruct, process, and generate figures
`./data_in/` - the data input directory
`./data_out/` - the reconstruction and processing output directory

### License ###

See LICENSE

### Contributors ###

See contributors.txt
