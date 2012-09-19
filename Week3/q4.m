% The image wood.tif is blurred and contaminated by additive noise. 
% Build an experimental model for the impulse response of the image 
% degradation process, and implement (by not using the image deblurring 
% functions in Matlab) the constrained least squares inverse filter with 
% (a) Tikhonov regulariser; and (b) a regulariser that utilises the fact
% that the original image content is smoother in the x-axis direction 
% than in the y-axis direction. Experiment different regularisation 
% parameter values manually so that your final solution is matched 
% with the noise level ?2 = 1. 
%Explain your solution and compare and discuss the results.

wood = imread('wood.tif');