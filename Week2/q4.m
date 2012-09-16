% Question 2.4
% Jens Raaby
% September 2012
clear all;
original = im2double(imread('interference.tif'));
[X, Y] = size(original);
P = 2*X; 
Q = 2*Y;

%Create a zero-padded version of the image to find the spectra
    f_big_padded          = zeros(P,Q);
    f_big_padded(1:P,1:Q) = original;
    
    % Compute the Discrete Fourier Transform of the padded image:
    F_big  = fft2(f_big_padded);
    
    imshow(log(1+abs(fftshift(F_big))),[]);
    
% The image interference.tif has been corrupted by noise and a systematic 
% interference pattern. Please describe the noise and inference patterns 
% and develop, implement, describe, and apply a program for removing as 
% much of the noise and interference pattern as possible. 
% Show (and explain) the results. The program need not to be fully 
% automatic, but may include interactive input, e.g. using the MATLAB-function ginput.

% discuss noise, low frequency patterns. use the frequency spectrums to
% help analysis