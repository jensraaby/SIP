 % spatial filtering - GW 3.4
% 3x3 mask, variable coefficients


inputimg = 'barbara.tif';
original= mat2gray(imread(inputimg));
%%
wgrad = [-1, 0, 1;-1, 0, 1;-1, 0, 1];
wavg = 1/9 * ones(3,3);

imshow(spatialFilter(original,wgrad'));

%%
% write box filter NxM. N = 2n+1 (n is input)
% function takes an image and value n
% how to deal with border?
% what does increasing n do?
n = 4;
imshow(boxFilter(original,n));

%%
% play with signal processing toolbox - compare 2 or more 1D window
% functionsto the rectangular window in the time and Fourier domain


%%
w = [1,1,-1,-1];
s = [1,2,3,2,1,0,-1,-2];
% plot(conv(s,w))
dft = fft(conv(s,w));
plot(real(dft));
hold on;
paddeds = zeros(11,1);
paddeds(3:10) = s;
plot(paddeds,'r');