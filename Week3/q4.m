% The image wood.tif is blurred and contaminated by additive noise. 
% Build an experimental model for the impulse response of the image 
% degradation process, and implement (by not using the image deblurring 
% functions in Matlab) the constrained least squares inverse filter with 
% (a) Tikhonov regulariser; and (b) a regulariser that utilises the fact
% that the original image content is smoother in the x-axis direction 
% than in the y-axis direction. Experiment different regularisation 
% parameter values manually so that your final solution is matched 
% with the noise level ?2 = 1. 

%Explain your solution and compare and discuss the results.
clear all;
wood = imread('wood.tif');
wood = im2double(wood);

%% Test a few different blur filters
[M,N] = size(wood);
H = fspecial('motion',2,0);
Hv = fspecial('motion',9,90);

Hb = Hv * H;
Hg = fspecial('gaussian',3,0.5);

impulse = zeros(100);
impulse(100/2,100/2) = 1;

Fi  = fft2(impulse);
Hi = fft2(Hg,100,100);

filtered = imfilter(impulse,Hv,'replicate');
imshow(filtered);
M=200;
N=M;

Hvg = fft2(Hg,M,N).*fft2(Hv,M,N);
% imshow(abs(fftshift(Fi.*Hvg)));

%%  Basic inverse transform - not good
G = fft2(wood);
H = fft2(Hg,M,N);
Ff = ifft(fftshift(G)./fftshift(H));
imshow(real(Ff));

%% Simple convolution testing

[A,B] = size(wood);
M = A+2;
N = B+2;
laplace = [0,-1, 0;
          -1, 4,-1;
           0,-1, 0];

padded_ll = zeros(M,N);
padded_ll(1:3,1:3) = laplace;

padded_im = zeros(M,N);
padded_im(1:A,1:B) = wood;

g_e = conv2(padded_im,padded_ll);


%% Deconvolution with regularisation - the part that worked
len = 6;
theta = 0;
PSF = fspecial('motion',5,0);
PSF2 = fspecial('motion',6,90);
PSFcomb = (PSF2 * PSF);
impulse = zeros(100);
impulse(100/2,100/2) = 1;
% imshow(impulse);

wood = edgetaper(wood,PSFcomb);

[im,noise] = wiener2(wood);
filtered = imfilter(impulse,PSF);
reg = [0,-1,0; 
       0.5,4,0.5; 
       0,-1,0];

defiltered = deconvreg(wood,PSFcomb,5,[1e-9 1e9],reg);
figure;
subplot(1,2,1);
imshow(wood);
imwrite(wood,'report/q4-w.png');

subplot(1,2,2);
imshow(defiltered);

figure;
imshow(wiener2(defiltered));



%% sample some noise interactively from the defiltered image
[B,c,r] = roipoly(defiltered);
B = roipoly(B,c,r);
noise_var  = var(defiltered(B));
noise_mean = mean(defiltered(B));

%% manual deconvolution
[A,B] = size(wood);
M = 2*A;
N = 2*B;

gamma_init = 0.001;

% get the fourier transfer of the filter and image
H = fft2(PSFcomb,M,N);
H = fftshift(H);

g = wood;
g_padded = zeros(M,N);
g_padded(1:A,1:B) = g;
G = fft2(wood,M,N);
G = fftshift(G);

p = [0, -1,0;
    -1,4,-1;
    0,-1,0];

P = fft2(p,M,N);

P_conj = conj(P);

F_hat = (conj(H) ./ ((H.^2) + gamma_init*(P.^2))) .* G;

f_hat = real(ifft2(F_hat));
% f_hat = f_hat(1:A,1:B);

% r = reshape(g,1,A+B) - H*f_hat;
R = g_padded - H.*f_hat;
r = real(ifft2(R));
r = r(1:A,1:B);

%% find gamma value iteratively

notDone = 1;
n_norm = (A*B)*(noise_var+noise_mean^2);

a = 0.025*n_norm;
maxIt = 500;
while notDone && k<1e5 && maxIt >0,
    r_norm = norm(r);
    
    
    plus = n_norm + a;
    minus= n_norm - a;
    
    if r_norm == plus || r_norm == minus
        notDone = 0;
    end
    if r_norm < minus
        gamma_init = gamma_init + 0.001;
    elseif r_norm >= plus
        gamma_init = gamma_init - 0.001;
    end
    F_hat = (conj(H) ./ ((H.^2) + gamma_init*(P.^2))) .* G;
    f_hat = real(ifft2(F_hat));
    R = g_padded - H.*f_hat;
    r = real(ifft2(R));
    r = r(1:A,1:B);

    maxIt = maxIt -1;
end