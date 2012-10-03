%Training exercise 5.2: Play with the Matlab implementation of the Canny edge detector. 
% Are there parameter values more satisfying than others?
% Mandatory assignment 5.2 Implement your own Canny edge detector (don?t use Matlab one!)

%  hedge = vision.EdgeDetector;
%  hcsc = vision.ColorSpaceConverter(...
%          'Conversion', 'RGB to intensity');
%  hidtypeconv = ...
%    vision.ImageDataTypeConverter('OutputDataType','single');
%  img = step(hcsc, imread('20120623-Sverige-_JPR9645.jpg'));
%  img1 = step(hidtypeconv, img);
%  edges = step(hedge, img1);
%  imshow(edges);

img = imread('20120623-Sverige-_JPR9645.jpg');
