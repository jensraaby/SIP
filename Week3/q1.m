% Simulate signal - draw 100 samples of signal

%% Gaussian mu=0, sigma=0.5
gaussian = normrnd(0,0.5,[1 100]);
% subplot(2,1,1);
% plot(sort(gaussian),1:1:100);
% subplot(2,1,2);
% plot(1:1:100,sort(fft(gaussian)));
% reverse engineer noise parameters - inspect fourier

% or, do it by hand
mu_est2 = mean(gaussian);
sig_est2 = var(gaussian);

%% Gamma a=1,b=1
gamma = gamrnd(1,1,[1 100]);

% subplot(2,1,1);
% plot(1:1:100,sort((gamma)));
% subplot(2,1,2);
% plot(1:1:100,sort(fft(gamma)));

%reverse engineer
distparmgamma = fitdist(gamma','gamma');
a_est = distparmgamma.a;
b_est = distparmgamma.b;
mean_est = mean(gamma); % = b/a
var_est  = var(gamma); % = b/(a^2)

% they are both multiplied by b

%%
% Uniform a=0,b=2
%uniform = 2.*rand(1,100); manual version
uniform = unifrnd(0,2,1,100);
% plot(1:1:100,sort(fft(uniform)));
[ahat,bhat] = unifit(uniform);
% distparm_uni = fitdist(uniform','uniform');
% dumb method
%mean_est = mean(uniform);
%aplusb_est = 2*mean_est;

% a + (b-a).*rand(100,1)
%%
% Salt and pepper 0.1, 0.2
% 10 x 10 salt and pepper noise converted to vector
% this feels a bit hacky
% see http://octave-image.sourcearchive.com/documentation/1.0.8-3/imnoise_8m-source.html
image = ones(10,10);
density_a = 0;
val_a = 0.1;
density_b = 2;
val_b = 0.2;
%image =  imnoise(image,'salt & pepper',[density_a,val_a]);
%image_b =  imnoise(image,'salt & pepper',[density_b,val_b]);
% image(image(:)==0) = 0.1;
% image(image(:)==1) = 0.2;
sandp = reshape(image,1,100);

%better method
% generate uniform random from 0 to 1
%  if value=0
   % set to intensity 0.1
  % if value = 2
   % set value to 0.2
   % otherwise 
   % set value to 1 - 0.3
% uniarr = 2*rand(1,100);
% for i=1:100
%     if uniarr(i) <= 0.1
%         myarr(i) = 0;
%     elseif uniarr(i) > 0.1 && uniarr(i) <= 2
%         myarr(i) = 2;
%     else
%         myarr(i) = 0.5;
%     end
%     
% 
% end

%generate uniform random and then extend some values to low and high

%Invent and develop a non-interactive method to estimate the noise 
% parameters of the simulated samples above assuming the respective 
% noise model but now assuming that the parameters are unknown. 
% Discuss your estimation results. Describe how would you use your
% estimation method with real images corrupted by noise.

% identify the noise type, then work out the parameters