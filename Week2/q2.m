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
imshow(barbara_lp);
imwrite(barbara,'report/q2-barbara.png','png');


%% Gaussian High Pass Filter
% As per GW section 4.9.3, the Gaussian High Pass filter is defined as
% (1 - the low pass filter)
D0 = 100;
H_hp = 1 - gaussianLowPass(P,Q,D0);
barbara_hp = applyFilter(barbara,H_hp);
imshow(barbara_hp);


%% High frequency emphasis filter:
D0 = 100;
% Set k to 1 for Unsharp mask, k>1 for 'High Boost'
k = 1;
H_lp  = gaussianLowPass(P,Q,D0);
H_hp  = 1 - H_lp;
H_hfe = 1 + (k * H_hp);

barbara_lp  = applyFilter(barbara,H_lp);
barbara_usm = applyFilter(barbara_lp,H_hfe);
barbara_hfe = applyFilter(barbara_lp,H_hfe);
imshow(barbara_usm);
imwrite(barbara_usm,'report/q2-hfe-100.png','png');



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
