img = imread('lena.bmp');
[W, H] = size(img);


%% encode
originalsize_bits = W*H*8;
binimg = dec2bin(img);
newbits = 5;
msbits = binimg(1:W*H,1:newbits);
compressedsize_bits = W*H*newbits;

sig = repmat([3 3 1 3 3 3 3 3 2 3],1,50); % Data to encode
symbols = [1 2 3]; % Distinct data symbols appearing in sig
p = [0.1 0.1 0.8]; % Probability of each data symbol
dict = huffmandict(symbols,p); % Create the dictionary.
hcode = huffmanenco(sig,dict); % Encode the data.
dhsig = huffmandeco(hcode,dict); % Decode the code.
%% decode
msbits2 = zeros(1:W*H,1:8);
msbits2 = dec2bin(msbits2);

msbits2(1:W*H,1:newbits) = msbits;
msdec = reshape(bin2dec(msbits2),W,H);
msdec = im2double(msdec);
%% analysis
error = sqrt(meansquarederror(im2double(img),msdec));
snr_ms = signalnoiseratio(im2double(img),msdec); 
%%
% huffman
% generate the histogram
I = imhist(img);

% normalise the probabilities
I_norm = I/sum(I);

% work out the number of bits needed (on average)
L_avg = 0;
for i=1:length(I)
    L_avg = L_avg + (8*I_norm(i));
end
%%
% find out how many symbols we need
zeroed = find(I_norm==0);
num_symbols = 256 - length(zeroed);

% get the interesting elements
interesting = find(I_norm ~= 0);

% sort from lowest probability to highest
[sorted_I,idx] = sort(I_norm(interesting));

% check that no info has been lost yet!
if (W*H) ~= sum(sorted_I * sum(I))
    error('we lost information already. crazy');
end

% successively combine the two bins of the lowest value until only one bin remains.


% arithenco

%%
% img = imread();
quanta = 50;
img = double(img) / 255;
img = uint8(img * quanta);
img = double(img) / quanta;


%%
load mask
image(X)
axis square
colormap(pink(255))
title('Original Image: mask')

%%
wcompress()