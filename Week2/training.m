 % spatial filtering - GW 3.4
% 3x3 mask, variable coefficients


inputimg = 'barbara.tif';
original= mat2gray(imread(inputimg));
%%
wgrad = [-1, 0, 1;-1, 0, 1;-1, 0, 1];
wavg = 1/9 * ones(3,3);

imshow(spatialFilter(original,wavg));

%%
% write box filter NxM. N = 2n+1 (n is input)
% function takes an image and value n
% how to deal with border?
% what does increasing n do?
n = 0;
imshow(boxFilter(original,n));

%%
% play with signal processing toolbox - compare 2 or more 1D window
% functionsto the rectangular window in the time and Fourier domain
