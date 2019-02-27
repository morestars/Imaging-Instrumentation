* ambient light
* long exposure
* short exposure
* dark current get summed at high exposure, so dark regions can't be detected well
* 8-bit computer displays
* 19 bit human eyes
* fancy computers can have higher grayscale bits for medical images
* log of data nonlinearly stretches the data to accentuate the dark and lose some of the bright region
* derivativ of log(img) to find edges
* keep edges (tight differences in luminance), but scale down the big ones
* Integrate in (e) to get back, but it's in 1D and we have a 2D image
* Integration is a linear operation
* Convolution in Matlab for pairwise 1-1 filters
* Taking the inverse of a gradient is difficult 
* Conjugate gradients for Ax = b to find the inverse applied to a vector
* Exponentiate to get from (e) to (f)
