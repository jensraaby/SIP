% The Matlab function scale.m computes convolution of images with Gaussian 
%      in the Fourier domain. It uses reflective boundary conditions. 
% Use it and implement an edge detector based on maximum of gradient magnitude. 
% Use several images of different levels of complexity. 

% Report only 2 or 3 of them. Do the same with the Marr-Hildreth edge detector. 

% Explain differences.


% I = fft2 of an image
% 

Ih = (imread('house.tif'));
Ip = (rgb2gray(imread('paddle 001.jpg')));
Ibridge = rgb2gray(imread('bridge.jpg'));
Ib = imread('barbara.tif');
Ir = imread('rice.tif');
img = Ib;

[M N] = size(img);

img = im2double(img);
img = imfilter(img,fspecial('gaussian',[7 7],5),'symmetric');
Mirrored = zeros(2*M,2*N);
Mirrored(1:M,1:N) = img;
Mirrored(1:M,N+1:2*N) = fliplr(img);
Mirrored(M+1:M*2,1:N) = flipud(img);
Mirrored(M+1:M*2,N+1:2*N) = fliplr(flipud(img));


%Fmir = fftshift(fft2(Mirrored));
Fmir = (fft2(Mirrored));

% Ip is now padded with reflection padding
figure(1);
subplot(1,2,1);
imshow(log(1+abs((Fmir))),[]); %remember scale to 0 1
subplot(1,2,2);
imshow(Mirrored);
%% Use scale on Fourier image
sigma = 1;
Ix = scale(Fmir,sigma,0,0); % 0 0 gaussian smooth
sigma = 1;
Ix = scale(Ix,sigma,0,1); % 0 1 first order x (vertical lines)
sigma = 1;
Iy = scale(Fmir,sigma,1,0); % 1 0 first order y (horizontal lines)

% all gradients



% imshow(log(1+abs((Is))),[]);

% ixy = ifft2(Ixy);
ix = ifft2(Ix);
iy = ifft2(Iy);
ixy = abs(ix) + abs(iy);
% set min thresh and max thresh
thresh = 0.03;
ixy2=ixy;
ixy2(ixy>thresh)= 1;
ixy2(ixy<=thresh)= 0;
figure(1);
imshow(ixy2(1:M,1:N),[]);



%% convolve the gaussian result by laplacian
% laplacian = [0,-1,0;-1,4,-1;0,-1,0];
% L = fft2(laplacian,size(Ix,1),size(Ix,2));
% I3 = L.*(Iy+Ix);
% I3 = ifft2(I3);
% figure(2);
% imshow(I3(1:M,1:N))

%% laplace is 2nd order derivative s
sigma = 1;
Ixx = scale(Fmir,sigma,0,2);
sigma = 1;
Iyy = scale(Fmir,sigma,2,0);
% imshow(ifft2(Iyy),[]);

ixx = ifft2(Ixx);
iyy = ifft2(Iyy);
ll = abs(ixx)+abs(iyy);
threshl = 0.000000001;
thresh = 0.002;
showthis = ll;
showthis(ll<thresh & ll>threshl) = 1;
showthis(ll>=thresh & ll<=threshl) = 0;
% showthis(ll<thresh) = 1;
% showthis(ll>=thresh) = 0;
imshow(showthis,[]);
% show the second derivative
% imshow(ll(1:M,1:N),[]);
% show the zero values
imshow(showthis(1:M,1:N),[]);
% find values close to 0 (should be edges)

%%
angle = atan(Iy/Ix);

%%
w1h = [ 1;-1];
w1v = [-1; 1];

laplace = [0,-1,0;-1,4,-1;0,-1,0];
sobelh = [-1,-2,-1;0,0,0;1,2,1];
sobelv = sobelh';
prewitth = [-1,-1,-1;0,0,0;1,1,1];
prewittv = prewitth';

robertsh = [-1,0;0,1];
robertsv = [0,-1;1,0];

test = imfilter(im2double(Ir),prewittv);
test2 = imfilter(im2double(Ir),prewitth);
test3= test2+test;
% imshow(test);
figure;
magnitude = sqrt(test.^2 + test2.^2);
direction = atan(test./test2);
imshow(magnitude,[]);

%% blur it 
blurred = imfilter(Ir,fspecial('gaussian',[3 3],0.5),'symmetric')