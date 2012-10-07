% Jens Raaby, SIP Ex 5.3

%% Lena
clear all
lena = im2double(imread('Lena.tif'));
[~,lenat] = doublethreshold(im2double(imread('Lena.tif')),0.002);
figure, imshow(lenat);
%% Save images for report
tic
[~,lenat] = doublethreshold(im2double(imread('Lena.tif')),0.002);
toc
imwrite(lenat,'report/q3-lena-0002.png');
tic
[~,lenat] = doublethreshold(im2double(imread('Lena.tif')),0.01);
toc
imwrite(lenat,'report/q3-lena-001.png');

tic
[~,lenat] = doublethreshold(im2double(imread('Lena.tif')),0.02);
toc
imwrite(lenat,'report/q3-lena-002.png');
tic
[~,lenat] = doublethreshold(im2double(imread('Lena.tif')),0.2);
toc
imwrite(lenat,'report/q3-lena-02.png')

%% Yeast
yeast = im2double(imread('Fig1048(a)(yeast_USC).tif'));

[~,yeastt] = doublethreshold(yeast,0.04);
figure,imshow(yeastt);
%% Remove smallest objects

BW = yeastt ; 
CC = bwconncomp(BW,4);
numPixels = cellfun(@numel ,CC.PixelIdxList); 

for k=1:(43-13)
    CC = bwconncomp(BW,4);
    numPixels = cellfun(@numel ,CC.PixelIdxList); 
    [smallest , idx] = min( numPixels ) ; 
    BW(CC.PixelIdxList{idx}) = 0;
end

figure,imshow(BW)
imwrite(BW,'report/q3-yeast-smallremoved-004.png');
%% Save report images
[~,yeastt] = doublethreshold(yeast,0.04);
imwrite(yeastt,'report/q3-yeast-004.png');

[~,yeastt] = doublethreshold(yeast,0.02);
imwrite(yeastt,'report/q3-yeast-002.png');

[~,yeastt] = doublethreshold(yeast,0.01);
imwrite(yeastt,'report/q3-yeast-001.png');