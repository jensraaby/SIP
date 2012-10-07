% The Matlab function scale.m computes convolution of images with Gaussian 
%      in the Fourier domain. It uses reflective boundary conditions. 
% Use it and implement an edge detector based on maximum of gradient magnitude. 
% Use several images of different levels of complexity. 

% Report only 2 or 3 of them. Do the same with the Marr-Hildreth edge detector. 

% Explain differences.


% I = fft2 of an image
% 
clear all
house = (imread('Fig1022(a)(building_original).tif'));
paddle = (rgb2gray(imread('paddle 001.jpg')));
bridge = rgb2gray(imread('bridge.jpg'));
barbara = imread('barbara.tif');
rice = imread('rice.tif');
lena = imread('Lena.tif');
blobs = imread('FigP1036(blobs).tif');
img = rice;
t = imread('Tshape.png');

[M N] = size(img);

img = im2double(img);
% blurring done by the scale function 
blurred = imfilter(img,fspecial('gaussian',[7 7],5),'symmetric');
[mirrored,Fmir] = mirrorpadding(img);

% Fmir = (fft2(Mirrored));

% Ip is now padded with reflection padding
figure(1);
subplot(1,2,1);
imshow(log(1+abs((Fmir))),[]); %remember scale to 0 1
subplot(1,2,2);
imshow(mirrored);


%% Test edgedetector

edged = edgedetector(mirrored,1,1,0.25);%'marr-hildreth');
imshow(edged(1:M,1:N),[]);

%% Lena
lena = im2double(imread('Lena.tif'));
[Ml,Nl] = size(lena);
[Mlena,~] = mirrorpadding(lena);
% interactiveEdgeDetector(lena);
edgedLena = edgedetector(Mlena,0.7,0.5,0.2,'basic');
edgedLenaMH = edgedetector(Mlena,4,4,6e-4,'marr-hildreth');

figure
imshow(edgedLenaMH(1:Ml,1:Nl));

imwrite(lena,'report/q1-lena-orig.png');
imwrite(edgedLena,'report/q1-lena-mag.png');
imwrite(edgedLenaMH,'report/q1-lena-mh.png');
%%  House
house = im2double(imread('Fig1022(a)(building_original).tif'));
imwrite(house,'report/q1-house-orig.png');
% house = im2double(barbara);
[Mh,Nh] = size(house);
[Mhouse,~] = mirrorpadding(house);
% % interactiveEdgeDetector(house);
edgedHouseBasic = edgedetector(Mhouse,0.6,0.7,0.3,'basic');
imwrite(edgedHouseBasic,'report/q1-house-mag.png');
% 8.0833e-04
edgedHouse = edgedetector(Mhouse,4,3.8,6.5e-04,'marr-hildreth');
imwrite(edgedHouse,'report/q1-house-mh.png');
% figure,imhist(edgedHouse,256);
figure(1);
imshow(edgedHouse(1:Mh,1:Nh),[]);
title('House');

%% laplace is 2nd order derivative
sigmax = 2;
Ixx = scale(Fmir,sigmax,0,2);
sigmay = 2;
Iyy = scale(Fmir,sigmay,2,0);
imshow(ifft2(Ixx),[]);

ixx = ifft2(Ixx);
iyy = ifft2(Iyy);
ll = abs(ixx)+abs(iyy);
magGrad = hypot(ixx, iyy);

 magmax = max(magGrad(:));
    if magmax > 0
        magGrad = magGrad / magmax;
    end
    %%
thresh = 0.01;
thresh = .75*mean2(abs(ll));
% showthis = ll;
% showthis(ll<thresh & ll>-thresh) = 1;
% showthis(ll>=thresh & ll<=-thresh) = 0;
% showthis(ll<thresh) = 1;
% showthis(ll>=thresh) = 0;
showthis = ll;
showthis(showthis<thresh) = 0;
showthis(ll>=thresh) = 1;
%imshow(showthis,[]);
% show the second derivative
% imshow(ll(1:M,1:N),[]);
% show the zero values
imshow(showthis(1:M,1:N),[]);
% find values close to 0 (should be edges)

%%
angle = atan(Iy/Ix);

%% Testing other gradient detectors
w1h = [ 1;-1];
w1v = [-1; 1];

laplace = [0,-1,0;-1,4,-1;0,-1,0];
sobelh = [-1,-2,-1;0,0,0;1,2,1];
sobelv = sobelh';
prewitth = [-1,-1,-1;0,0,0;1,1,1];
prewittv = prewitth';

robertsh = [-1,0;0,1];
robertsv = [0,-1;1,0];

test = imfilter(im2double(house),sobelv);
test2 = imfilter(im2double(house),sobelh);
test3= test2+test;
% imshow(test);
test4=imfilter(im2double(house),laplace);
figure;
magnitude = sqrt(test.^2 + test2.^2);
direction = atan(test./test2);
imshow(magnitude,[]);

%% blur it 
blurred = imfilter(Ir,fspecial('gaussian',[3 3],0.5),'symmetric')