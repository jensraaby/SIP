% Question 2.2
% Jens Raaby
% September 2012

clear all

% Load the original image
barbara = im2double(imread('barbara.tif'));
[X,Y] = size(barbara);

% Padding parameters:
P = 2*X; Q = 2*Y;

%% Gaussian Low Pass filter
% see gaussianLowPass.m for definition - I created a function to
% parameterise the cutoff frequency D0.
% -> in Cell mode the effect of changing the value of D0 can easily be seen.

D0 = 50;
H_lp = gaussianLowPass(P,Q,D0);

barbara_lp = applyFilter(barbara,H_lp);
figure(1);
imshow(barbara_lp);
title(sprintf('GLP, D0 = %d',D0));

%% Gaussian High Pass Filter
% As per GW section 4.9.3, the Gaussian High Pass filter is defined as
% (1 - the low pass filter)
D0 = 100;
H_hp = 1 - gaussianLowPass(P,Q,D0);
barbara_hp = applyFilter(barbara,H_hp);
figure(2);
imshow(barbara_hp);
title(sprintf('GHP, D0 = %d',D0));


%% High frequency emphasis filter:
D0 = 100;
% Set k to 1 for Unsharp mask, k>1 for 'High Boost'
k = 3;
H_lp  = gaussianLowPass(P,Q,D0);
H_hp  = 1 - H_lp;
H_hfe = 1 + (k * H_hp);
barbara_lp  = applyFilter(barbara,    H_lp);
barbara_hfe = applyFilter(barbara_lp, H_hfe);

% Display a comparison of the filtered images with the original
    figure(3);
    subplot(1,3,1);
    imshow(barbara_lp);
    title(sprintf('GLP, D0 = %d',D0));
    subplot(1,3,2);
    imshow(barbara_hfe);
    title(sprintf('GHFE, k = %d,  D0 = %d',k,D0));
    subplot(1,3,3);
    imshow(barbara);
    title('original');



%% Compare cutoff values - saves results to report directory
for cutoff = 50:50:200
    clear lp_tmp hp_tmp;
    lp_tmp = gaussianLowPass(P,Q,cutoff);
    hp_tmp = 1 - lp_tmp;

    LPfname=sprintf('report/q2-lowpass-%d.png',cutoff);
    imwrite(applyFilter(barbara,lp_tmp),LPfname,'png');
    
    HPfname=sprintf('report/q2-highpass-%d.png',cutoff);
    imwrite(applyFilter(barbara,hp_tmp),HPfname,'png');
end
