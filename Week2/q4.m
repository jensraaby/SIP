% Question 2.4
% Jens Raaby
% September 2012
clear all;
original = im2double(imread('interference.tif'));
[X, Y] = size(original);
P = 2*X; 
Q = 2*Y;


%% Find the frequencies of the patterns

% identify coordinates of points that need to be notched away

% First generate Fourier transform and show it:
% original = imread('noiseball.png');
F=fftshift(fft2(original));
h=figure();
eh=msgBox('Click the peak frequencies carefully. Then press Return when done.','What to do next');
uiwait(eh);
% collect notch coordinates by clicking on the peaks on the image
% press enter when done
imshow(log(1+abs(F)),[]);
[x,y] = ginput;
close(h);

notches = length(x);

%% Plot the chosen points to check them (optional)

figure;
imshow(log(1+abs((F))),[]);
hold on;
for i=1:notches
    plot(x(i),y(i),'gx');
end
hold off;


%% loop through all the notches and filter the image

D0 = 10;
G = ones(P,Q);
x = round(x);
y = round(y);
x = 2*x;
y = 2*y;
H = zeros(P,Q,notches);
% generate a filter for each centering
for n=1:notches
    % really I should calculate the optimal cutoff values for each notch 
    % as half the distance from the centre
    H(:,:,n) = notchFilter(P,Q,D0,x(n),y(n));
end

% DFT of the image, padded:
F=fft2((original),P,Q);

% Multiply all the notch filters together:
H_notch = ones(P,Q);
for n=1:notches
    H_notch = H_notch .* H(:,:,n);
end

% Filter the image with the combined notch filter:
G = F .* H_notch;

% Display the result
%   First convert result to spatial domain and remove padding:
g = real(ifft2(G));
g = g(1:X,1:Y);
figure(2); 
imshow(g,[]);



%% Examine spectra

% Shift the spectra of the image and the filtered image
Fourier_image = fftshift(F);
Fourier_filtered = fftshift(G);
% Display the spectra
figure(3);
subplot(1,2,1);
imshow(log(1+abs(Fourier_image)),[]);
subplot(1,2,2);
imshow(log(1+abs(Fourier_filtered)),[]);

%% Try to remove noise with low pass
D0 = 100;
smoothed = applyFilter(g,gaussianLowPass(P,Q,D0));
imshow(smoothed,[]);