function image_ = gammaTransform( image, gamma )
%GAMMATRANSFORM Summary of this function goes here
%   Detailed explanation goes here
    image_ = im2double(image);
    
    
    
    image_ = image_ .^ gamma;
   
    
    % % gamma correction:
% % image r -> r^gamma
% 
% image = imread('barbara.tif');
% image = im2double(image); % because cannot do double point power of int.
% gamma = 3.3;
% 
% s = image .^ gamma;
% imshow(s);

end

