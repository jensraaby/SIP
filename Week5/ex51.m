% Jens Raaby, SIP Ex 5.1

%% Rice
rice = im2double(imread('rice.tif'));
[Ml,Nl] = size(rice);
[Mrice,~] = mirrorpadding(rice);
% interactiveEdgeDetector(lena);
edgedRice = edgedetector(Mrice,0.7,0.5,0.3,'basic');
edgedRiceMH = edgedetector(Mrice,4,4,9e-4,'marr-hildreth');

figure
imshow(edgedRiceMH(1:Ml,1:Nl));

%%
imwrite(rice,'report/q1-rice-orig.png');
imwrite(edgedRice,'report/q1-rice-mag.png');
imwrite(edgedRiceMH,'report/q1-rice-mh.png');


%% Lena
lena = im2double(imread('Lena.tif'));
[Ml,Nl] = size(lena);
[Mlena,~] = mirrorpadding(lena);
% interactiveEdgeDetector(lena);
edgedLena = edgedetector(Mlena,0.7,0.5,0.2,'basic');
edgedLenaMH = edgedetector(Mlena,4,4,6e-4,'marr-hildreth');

figure
imshow(edgedLenaMH(1:Ml,1:Nl));

%%
imwrite(lena,'report/q1-lena-orig.png');
imwrite(edgedLena,'report/q1-lena-mag.png');
imwrite(edgedLenaMH,'report/q1-lena-mh.png');


%%  House
house = im2double(imread('Fig1022(a)(building_original).tif'));

% house = im2double(barbara);
[Mh,Nh] = size(house);
[Mhouse,~] = mirrorpadding(house);
% % interactiveEdgeDetector(house);
edgedHouseBasic = edgedetector(Mhouse,0.6,0.7,0.3,'basic');

% 8.0833e-04
edgedHouse = edgedetector(Mhouse,4,3.8,6.5e-04,'marr-hildreth');

% figure,imhist(edgedHouse,256);
figure(1);
imshow(edgedHouse(1:Mh,1:Nh),[]);
title('House');
%%
imwrite(house,'report/q1-house-orig.png');
imwrite(edgedHouseBasic,'report/q1-house-mag.png');
imwrite(edgedHouse,'report/q1-house-mh.png');