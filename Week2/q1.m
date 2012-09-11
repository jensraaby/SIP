%Implement a 2-D filtering program ?package? that makes the filtering in 
%the Fourier domain, given either the impulse response of the filter in the
% spatial domain, or the transfer function in the Fourier domain. 

% You may use the MATLAB implementation of the FFT (and fftshift, ifftshift) 
% and but other parts of the programme you should program yourself 
% (not to use functions from the image processing toolbox). 

% Your implementation must have the capabilities to:
%(a) Extend the image and the filter by zero padding to avoid wrap around error.
%(b) Performing the filtering in the Fourier domain.
%(c) Visualise the image, the filter, and the filtering result, in both 
% spatial and Fourier domain, so that the the frequency response is centred on the Fourier domain.

%Test the implementation, by filtering the given test image testimg.tif 
% by 5 × 5 averaging filter, and the ideal low pass filter, and 
% compare the results. Explain what you did and the results you obtained.