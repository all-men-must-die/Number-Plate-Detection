# Number-Plate-Detection
MATLAB code for detecting the number plate of a vehicle from a still image

This code has been written on MATLAB and uses horizontal and vertical histogram analysis for the detection of the number plate. 
The code takes into account that the number plate region has pixels which have a very high intensity (the white part)
and regions that have a very low intensity (the text). Thus, by plotting the differences in the pixel intensities and taking
the regions with the maximum variations according to a preset threshold, the number plate of the vehicle is extracted.
