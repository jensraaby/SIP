% histogram equalisation

image = imread('barbara.tif');
t = histogram_equalise(image);
bh = figure,imhist(image);
ah = figure,imhist(t);
print(bh,'-dpdf','report/q4-b-orighist.pdf');
print(ah,'-dpdf','report/q4-b-thist.pdf');
imwrite(image,'report/q4-orig.png');
imwrite(t,'report/q4-equal.png');


%% Histogram matching
match_vec = zeros(size(im_vec));
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

%%
    
    [M N] = size(image);
    
    n = numel(image);
    
    % normalise supplied histograms (sum to 1)
    h = imhist(image);
    h = h./sum(h);
    h_s = length(h);
    h2 = hist_trans;
    h2 = h2/sum(h2);
    h2_s = length(h2);
        
    % Build the cumulative distribution of image histogram and new histogram
    cumulative = zeros(1,length(h));
    cumulative_new = zeros(1,length(h2_s));

    cumulative(1) = h(1);
    cumulative_new(1) = histogram(1);
    for j = 2:h_s
        cumulative(j) = cumulative(j-1) + h(j);
        cumulative_new(j) = cumulative_new(j-1) + histogram(j);
    end
    
    % Find the indices in the specimen histogram which are closest to the
    % values in the original histogram
    lookup = zeros(h_s);
    j = 1;
    for i=1:256
        if (cumulative(i) <= cumulative_new(j))
            lookup(i)=j;
        else
            while (cumulative(i) > cumulative_new(j)) && j<=256
                j=j+1;
            end
            if (cumulative_new(j) - cumulative(i)) > (cumulative(i) - cumulative_new(j-1))
                j = j-1;
                lookup(i) = j;
            else
                lookup(i) = j;
            end
        end
    end
    
    im_vec = reshape(image,1,n);
    t_vec = zeros(size(im_vec));
    for k=1:n
        t_vec(k) = lookup(im_vec(k));
    end
    t = cast(reshape(t_vec,M,N),'uint8');
 %%
 image = imread('_JPR9397.tif');
 imwrite(image,'report/q4b-orig.png');
 h1 = figure;
 imhist(image);
 print(h1,'-dpdf','report/q4-c-orighist.pdf');
 
 image2 = imread('grass.tif');
 imwrite(image2,'report/q4b-match.png');
 h2 = figure;
 imhist(image2);
 print(h2,'-dpdf','report/q4-c-spechist.pdf');
 
 result = histogram_match(image,imhist(image2));
 imwrite(result,'report/q4b-result.png');
 h3 = figure;
 imhist(result);
 print(h3,'-dpdf','report/q4-c-thist.pdf');

 