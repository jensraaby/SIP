barbara=imread('barbara.tif');
    

% do the inversion:
inverted = rangetransform(barbara,150,0);
imshow(inverted);
