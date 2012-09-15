% Implement image resizing using signal processing techniques. Do not use
% the image resizing tools available in image processing toolbox.

% In the downsamping, design as good anti-aliasing filter as you can, and 
% shrink the original barbara.tif image by the factor of 4 by simple 
% resampling with and without using the anti-aliasing filter, and compare 
% the results. Illustrate the spectrum before and after using the 
% anti-aliasing filter. Report how you designed the anti-aliasing filter you chose, and why.

% naiive = delete alternating rows and columns
% better = smooth then reduce
% even better? = supersample then delete cols and rows (not possible unless
%  you have access to the original source)

% In the upsampling, pad zeros between the original samples so that the 
% image size grows by the factor of 3 in both dimensions. Illustrate the 
% spectrum before and after adding the zeros and design an appropriate 
% filter to remove the mirrored parts of the spectrum as well as possible.
% Explain what you did and the reflect the results.

% interpolation:
% - nearest neighbour
% -   special case: pixel replication (e.g. double columns, then double
% rows)
% - bilinear
% - bicubic