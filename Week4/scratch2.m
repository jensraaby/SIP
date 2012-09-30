clear

tic
rgb_image = imread('grass-rgb.tif');

%RGBTOHSI Converts a given image in RGB to HSI representation

[M N P] = size(rgb_image);
n = numel(rgb_image)/P;
hsi_image = zeros(M, N, 3);

% separate the channels and convert to normalised double:
if P==3
    R = im2double(rgb_image(:,:,1));
    G = im2double(rgb_image(:,:,2));
    B = im2double(rgb_image(:,:,3));
end


% for each chanel, vectorise
R_v = reshape(R,1,n);
G_v = reshape(G,1,n);
B_v = reshape(B,1,n);

summed = R_v + G_v + B_v;
i = summed/3;
I = reshape(i,M,N);

s = summed - 3*min([R_v; G_v; B_v],[],1);

problematic = find(summed==0);
summed(problematic) = 0.1; % avoid divide by zero!
s = s./(summed);

S = reshape(s,M,N);

% handle the 360 subtraction using the bigger indices:
bigger = find(B_v-G_v > 0);
h = 0.5*((2*R_v) - G_v - B_v);
denom = (R_v.^2) + (B_v.^2) + (G_v.^2) - (R_v.*G_v) - (R_v.*B_v) - (B_v.*G_v);
h = h./(sqrt(denom));
h(bigger) = 360 - h(bigger);
H = reshape(h,M,N);



hsi_image(:,:,1) = H;
hsi_image(:,:,2) = S;
hsi_image(:,:,3) = I;
toc

%% Inverse
clear R G B R_v G_v B_v
tic

[M N P] = size(hsi_image);
n = numel(hsi_image)/P;

% separate the channels and convert to normalised double:
if P==3
    H = (hsi_image(:,:,1));
    S = (hsi_image(:,:,2));
    I = (hsi_image(:,:,3));
end


% for each channel, vectorise
H_v = reshape(H,1,n);
S_v = reshape(S,1,n);
I_v = reshape(I,1,n);


%
sub120 = find(H_v<120);
sub240 = find(H_v>=120 & H_v<240);
rest   = find(H_v>=240 & H_v<=360);

B(sub120) = I_v(sub120).*(1-S_v(sub120));
R(sub120) = I_v(sub120).*(1+(S_v(sub120).*cos(H_v(sub120))./cos(60-H_v(sub120))));
G(sub120) = 3*I_v(sub120) - R(sub120) - B(sub120);

H_v(sub240) = H_v(sub240) - 120;
R(sub240) = I_v(sub240).*(1-(S_v(sub240)));
G(sub240) = I_v(sub240).*(1+(S_v(sub240).*cos(H_v(sub240)))./cos(60-H_v(sub240)));
B(sub240) = 3*I_v(sub240) - R(sub240) - G(sub240);

H_v(rest) = H_v(rest) - 240;
G(rest) = I_v(rest).*(1-S_v(rest));
B(rest) = I_v(rest).*(1+(S_v(rest).*cos(H_v(rest)))./cos(60-H_v(rest)));
R(rest) = 3*I_v(rest) - B(rest) - G(rest);

rgb_image2(:,:,1) = reshape(R,M,N);
rgb_image2(:,:,2) = reshape(G,M,N);
rgb_image2(:,:,3) = reshape(B,M,N);

toc