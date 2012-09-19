% Using the Matlab documentation, study when you could use the wiener2 
% function for image enhancement.

%The images house.tif, ic.tif, and boxes.tif have been corrupted by noise. 
% Analyse what kind of noise there is in each image and recover the noise 
% free images as well as possible.
% Report your considerations and explain your solutions.

house = imread('house.tif');
ic = imread('ic.tif');
boxes = imread('boxes.tif');

%% Boxes
imhist(boxes);
% also looks Gaussian


%% House
imhist(house);
% salt and pepper
% find the two impulses(their intensity and their quantity (to get
% probability)


%% IC
imhist(ic);
% looks very gaussian!
distparm = fitdist(reshape(ic,size(ic,1)*size(ic,2),1),'normal');
mu_est = distparm.mean;
sig_est = distparm.var;