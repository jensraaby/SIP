% Question 2.3 - Image Resizing
% Jens Raaby
% September 2012

% Implement image resizing using signal processing techniques. Do not use
% the image resizing tools available in image processing toolbox.

clear all

% Load the original image
barbara = im2double(imread('barbara.tif'));
[X,Y] = size(barbara);

%% Downsampling
downScaleFactor = 4;

%remove columns
barbara_shrunk_aliased = barbara(:,1:downScaleFactor:Y);
%remove rows
barbara_shrunk_aliased = barbara_shrunk_aliased(1:downScaleFactor:X,:);
figure(1);
imshow(barbara_shrunk_aliased);
title('Shrunk Barbara');

%imwrite(barbara_shrunk_aliased,'report/q3-shrunk-aliased.png');
spectrumAliased = log(1+(abs(imageSpectrum(barbara_shrunk_aliased))));
figure(2);
imshow(spectrumAliased,[]);
title('Frequency spectrum of aliased shrunk Barbara');

%% Antialias by smoothing before downsampling
D0 = 100;
H_lp = gaussianLowPass(2*X,2*Y,D0);
barbara_lp = applyFilter(barbara,H_lp);
barbara_shrunk_smoothed = barbara_lp(:,1:downScaleFactor:Y);
barbara_shrunk_smoothed = barbara_shrunk_smoothed(1:downScaleFactor:X,:);
figure(2);
imshow(barbara_shrunk_smoothed);

figure(3);
spectrumAntiAliased = log(1+(abs(imageSpectrum(barbara_shrunk_smoothed))));
imshow(spectrumAntiAliased,[]);


%% Try the Unsharp Mask technique on the result:

D0 = 50;
% Set k to 1 for Unsharp mask, k>1 for 'High Boost'
k = 1;
[P, Q] = size(barbara_shrunk_smoothed);
P = P*2; Q = Q*2;
H_lp  = gaussianLowPass(P,Q,D0);
H_hp  = 1 - H_lp;
H_hfe = 1 + (k * H_hp);
barbara_shrunk_smoothed_sharpened = applyFilter(barbara_shrunk_smoothed,H_hfe);
figure(4);
imshow(barbara_shrunk_smoothed_sharpened);

%% averaging before reducing

FivebyFiveAveraging = 1/25 * ones(5);

averaged  = applyFilter(barbara,FivebyFiveAveraging,'spatial');
barbara_shrunk_smoothed2 = averaged(:,1:downScaleFactor:Y);
barbara_shrunk_smoothed2 = barbara_shrunk_smoothed2(1:downScaleFactor:X,:);
figure(5);
imshow(barbara_shrunk_smoothed2);


%% Upsampling
upScaleFactor = 3;
newX = upScaleFactor*X;
newY = upScaleFactor*Y;
barbara_grown_basic = zeros(newX,newY);

% add the original image over the zeros, leaving gaps
barbara_grown_basic(1:upScaleFactor:newX,1:upScaleFactor:newY) = barbara;

figure(6);
imshow(barbara_grown_basic,[]);
title('Barbara upsampled with zeros in between pixels');

% Create a zero-padded version of the images to find the spectra
    f_padded                    = zeros(X*2,Y*2);
    f_big_padded                = zeros(newX*2,newY*2);
    f_padded(1:X,1:Y)           = barbara;
    f_big_padded(1:newX,1:newY) = barbara_grown_basic;
    
    % Compute the Discrete Fourier Transform of the padded image:
    F_orig = fft2(f_padded);
    F_big  = fft2(f_big_padded);
    figure(7);
    imshow(log(1+abs(fftshift(F_orig))),[]);
    figure(8);
    imshow(log(1+abs(fftshift(F_big))),[]);
    
%% Low Pass
% Cutoff frequency seems to be ~200 to remove mirroring
D0 = 210;
H_big_lp = gaussianLowPass(2*newX,2*newY,D0);
barbara_big_lp = applyFilter(barbara_grown_basic,H_big_lp);
figure(10);

subplot(1,2,1);
imshow(barbara_big_lp,[]);
subplot(1,2,2);

%Create a zero-padded version of the images to find the spectra
    f_big_padded                = zeros(newX*2,newY*2);
    f_big_padded(1:newX,1:newY) = barbara_big_lp;
    
    % Compute the Discrete Fourier Transform of the padded image:
    F_big  = fft2(f_big_padded);
    
    imshow(log(1+abs(fftshift(F_big))),[]);
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