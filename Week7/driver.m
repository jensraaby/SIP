clear all
original_image = 'lena.bmp';
% original_image = 'ic.tif'
% original_image = 'barbara.tif'
img = imread(original_image);
original_file_info = dir(original_image);

% levels = wavelet levels
levels = 4;
% bin size - effects the quantization and thus compression
T = 5; % set to 0 for lossless
% threshold for coefficients - higher = less detail kept
% 0 = disable suppression of coefficients
thresh = 30;
% encode
encoded = jpr_encode_image(img,levels,T,thresh);
fname = sprintf('encoded_lena_thr%d_%d_%d.mat',thresh,levels,T);
save(fname,'encoded');
compressed_file_info = dir(fname);



%% load and decode
clear encoded T levels
load(fname);

decoded = jpr_decode_image(encoded);

snr = signalnoiseratio(img,decoded);

sizebefore = original_file_info.bytes;
sizeafter  = compressed_file_info.bytes;

compare = figure;
subplot(1,2,1);
imshow(img);
title('Original image');

subplot(1,2,2);
imshow(decoded);
tplot = sprintf('Recovered compressed image. SNR = %3f',snr);
title(tplot);

fprintf('SNR               = %2f\n',snr);
fprintf('Compression ratio = %2f\n',sizebefore/sizeafter);
% differnce image
figure,imshow(abs(img-decoded),[])
