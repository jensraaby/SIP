% Jens Raaby, SIP Ex 5.2

%% Lena
clear all
lena = im2double(imread('Lena.tif'));
edgedLena = cannydetector(lena,0.1,0.08,1);
figure, imshow(edgedLena);
%% Save images for report
imwrite(lena,'report/q2-lena-orig.png');
imwrite(cannydetector(lena,0.2,0.08,sqrt(2)),'report/q2-lena-canny-0200814.png');
imwrite(cannydetector(lena,0.2,0.08,4),'report/q2-lena-canny-020084.png');
imwrite(cannydetector(lena,0.1,0.08,1),'report/q2-lena-canny-010081.png');

%% House
clear all
house = im2double(imread('Fig1022(a)(building_original).tif'));
edgedHouse = cannydetector(house,0.15,0.06,3*sqrt(2));
figure, imshow(edgedHouse);
%% Save images for report
imwrite(house,'report/q2-house-orig.png');
imwrite(cannydetector(house,0.2,0.08,3),'report/q2-house-canny-020083-my.png');
imwrite(cannydetector(house,0.2,0.06,sqrt(2)),'report/q2-house-canny-02006rt2-my.png');
imwrite(cannydetector(house,0.15,0.06,3*sqrt(2)),'report/q2-house-canny-0150063rt2-my.png');
