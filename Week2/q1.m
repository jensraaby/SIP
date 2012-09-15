% Question 2.1
% Jens Raaby
% September 2012

%% Initialise
clear all;

image = im2double(imread('testimg.tif'));
[M N] = size(image);

% Calculate the padding dimensions:
P=M*2; Q=N*2;

%% Create a 5x5 averaging filter

FivebyFiveAveraging = 1/25 * ones(5,5);

averaged  = applyFilter(image,FivebyFiveAveraging,'spatial',true);

% pre-conversion to Fourier for testing the appleFilter function:
%FivebyFiveFourier = fftshift(fft2(FivebyFiveaveraging,P,Q));
%averagedF  = applyFilter(image,FivebyFiveFourier,'Fourier',true);

%% Create an ideal Low Pass filter

% set the cutoff frequency:
cutoff = 50;
LowPass = zeros(P,Q);
    for i=1:P
        for j = 1:Q
            % distance between current pixel and centre of padded image
            d_ij = sqrt((i-(P/2))^2+(j-(Q/2))^2);

            if (d_ij <= cutoff)
                LowPass(i,j) = 1;
            else
                LowPass(i,j) = 0;
            end
        end
    end
    
lowPassed = applyFilter(image,LowPass,'Fourier',true);

%% Save the results
% Using PNG as it seems to work better with my LaTeX installation.
imwrite((image),'report/q1-originaltest.png','png');
imwrite((averaged),'report/q1-averagedtest.png','png');
imwrite((lowPassed),'report/q1-lptest.png','png');

