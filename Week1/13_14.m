%Write a MATLAB program that reads an image, displays it, and saves the images. 
% Apply the program on the image idotyl.tiff available at the course home page on ABSALON. 
% Modify the programs such that it scales the image intensity values into the full dynamic range of [0:255].

image = imread('idotyl.tiff');

% original = figure();
% disp = imshow(image);

% find the range of shades in the original image
darkest = min(image(:))
lightest = max(image(:))

% use imagesc to scale the colour
scaled = figure();

colormap(gray);
doubleimage = im2double(image);

x = (b-a) * (x-m)/(M-m) + a;
normaliser = repmat(lightest,length(image),length(image));
rescaled = (doubleimage./normaliser);
% scaledimage = imagesc(image,[darkest lightest]);
imshow(rescaled);
% imwrite(rescaled,'scaled-idoty1.tiff','tiff');
