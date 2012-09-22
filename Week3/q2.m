% Using the Matlab documentation, study when you could use the wiener2 
% function for image enhancement.

%The images house.tif, ic.tif, and boxes.tif have been corrupted by noise. 
% Analyse what kind of noise there is in each image and recover the noise 
% free images as well as possible.
% Report your considerations and explain your solutions.




%% House
clear all
house = imread('house.tif');
% h_house = figure;
% imhist(house);
% print(h_house,'-dpsc','report/q2-househist.ps')
% close(h_house);
% imshow(house);
% hist(reshape(house,256);
g = im2double(house);

filtermask = ones(3);
% positive Q for removing pepper, negative for salt
Q_pepper = 1.5;
depeppered_house = imfilter(g.^(Q_pepper+1), filtermask, 'replicate');
depeppered_house = depeppered_house ./ (imfilter(g.^Q_pepper, filtermask, 'replicate'));


% remove salt
Q_salt = -10;
filtermask = ones(3);
desalted_house = imfilter(depeppered_house.^(Q_salt+1), filtermask, 'replicate' );
desalted_house = desalted_house ./ (imfilter(depeppered_house.^Q_salt, filtermask, 'replicate'));

figure;
subplot(1,3,1)
imshow(g);
subplot(1,3,2)
imshow(depeppered_house);
subplot(1,3,3);
imshow(desalted_house);

imwrite(house,'report/q2-house.png');
imwrite(depeppered_house,'report/q2-depeppered.png');
imwrite(desalted_house,'report/q2-desalted.png');
% figure
% subplot(1,2,2);
% imhist(desalted_house);

% salt and pepper
% find the two impulses(their intensity and their quantity (to get
lowimpulse  = 6;
highimpulse = 180;
% probability)


%% IC
clear all
ic = imread('ic.tif');
imwrite(ic,'report/q2-ic.png');
imhist(ic);
figure,imshow(ic);
% try wiener2 function
mask = [15 15];
ic_wienered = wiener2(ic,mask);
figure,imshow(ic_wienered);
imwrite(ic_wienered,'report/q2-icwienered.png');
imhist(ic_wienered);

%% Boxes
clear all
boxes = imread('boxes.tif');
imwrite(boxes,'report/q2-boxes.png');
h_boxhist = figure;
imhist(boxes);
print(h_boxhist,'-dpdf','report/q2-boxhist.pdf');
close(h_boxhist);

g = wiener2(im2double(boxes),[3 3]);
imwrite(g,'report/q2-boxes-wienered.png');
Q_salt = -10;
filtermask = ones(3);
desalted_boxes = imfilter(g.^(Q_salt+1), filtermask, 'replicate' );
desalted_boxes = desalted_boxes ./ (imfilter(g.^Q_salt, filtermask, 'replicate'));
imwrite(desalted_boxes,'report/q2-boxesdesalt.png');

h_boxhist2 = figure;
imhist(desalted_boxes);
print(h_boxhist2,'-dpdf','report/q2-boxhist-after.pdf');
close(h_boxhist2);