%In figure sky.jpg, assume that one has imaged the night sky by using a long exposure time.
clear all
sky = imread('sky.tif');
sky = im2double(sky);

imshow(((sky)));
hold on
plot(440,335,'r.');
hold off

%% measure angle
angle = 8.84;
% use formula from web to find time in minutes:
minutes = (angle/2.5) * 10
seconds_part = 60 * (minutes - floor(minutes))