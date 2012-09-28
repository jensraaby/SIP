% histogram equalisation

image = imread('barbara.tif');
[M N] = size(image);
h = imhist(image);
n = numel(im_vec);

im_vec = reshape(image,1,n);

% Build the cumulative distribution of intensity hists
cumulative = zeros(1,length(h));
cumulative(1) = h(1);
for j = 2:length(h)
    cumulative(j) = cumulative(j-1) + h(j);
end

% Build the equalised image vector
eq_vec = (zeros(size(im_vec)));
for i=1:n
   eq_vec(i) = cumulative(im_vec(i))/n; 
end

t = reshape(eq_vec,M,N);

match_vec = zeros(size(im_vec));

%% Histogram matching
image2 = imread('cameraman.tif');

hist_trans = imhist(image2);

% Build the cumulative distribution of the transforming histogram
cumulative_trans = zeros(1,length(hist_trans));
cumulative_trans(1) = hist_trans(1);
for j = 2:length(hist_trans)
    cumulative_trans(j) = cumulative_trans(j-1) + hist_trans(j);
end
%normalise
cumulative_trans = cumulative_trans./max(cumulative_trans);
cumulative_orig = cumulative./max(cumulative);
% Create a mapping matrix
mapping = zeros(256,2);
for i = 1:256
    mapping(i,1) = cumulative(i);
    mapping(i,2) = cumulative_trans(i);
end
% given some intensity x, find the value of mapping(x,1). then find the
% value in mapping(j,2) which has same value and return j

% 
% function s = Teq(im)
%     
% end