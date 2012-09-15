% Question 2.2
% Jens Raaby
% September 2012


% Implement the Gaussian lowpass and high pass filter (GW Sec. 4.8.3 and 
% 4.9.3) and apply it to the barbara.tif image. Evaluate the filtering 
% result on couple of cut-off frequencies and explain the results you get. 
% 
% H(u,v) = e^(-i * D^2(u,v) / (2 * sigma^2))
% let sigma = D0
% H(u,v) = e^(-i * D^2(u,v) / (2 * D0^2))
original = mat2gray(imread('barbara.tif'));
[X,Y] = size(original);
P = 2*X;
Q = 2*Y;
H = zeros(P,Q);
centrex = round(P/2);
centrey = round(Q/2);
D0 = 10;
for x=1:P
    for y=1:Q
        d_tmp = (x - centrex).^2 + (y - centrey).^2;
        H(x,y) = exp(-d_tmp / 2 / D0 / D0);
    end
end

Hlp = H;

Hhp = 1 - H;


% High frequency emphasis filter:
k = 2;
Hhfe = 1 + (k*Hhp);

[imageLP,~] =filteringPackage(original,Hlp);
%%
[image,~] =filteringPackage(imageLP,Hhfe);
imtool(image);
% Then using the Gaussian high pass filter, implement a high-frequency 
% emphasis filter for sharpening an image. Try to invert your low-pass 
% filtered result above by filtering it with the high-frequency emphasis
% filter (GW Sec. 4.9.5). Explain the results you get. Is the inversion feasible?