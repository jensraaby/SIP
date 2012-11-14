clear all


%% Examples with leaves
leaves{1} = imcomplement(imread('leaf1bw.png'));
leaves{2} = imcomplement(imread('leafbw2.png'));
leaves{3} = imcomplement(imread('leafbw3.png'));
leaves{4} = imcomplement(imread('leafbw4.png'));

% number of components to keep
Keep = 3
for i = 1:length(leaves)
    
    % Get the image and its boundary
    img = leaves{i};
    boundaries = bwboundaries(img,8);
    
    % Decimate
    recovered_boundaries = jpr_fourier_decimate(boundaries{1},Keep);
    
    % Store the new boundary as an image
    idx = sub2ind(size(img), recovered_boundaries(:,1), recovered_boundaries(:,2));
    im_rec= zeros(size(img));
    im_rec(idx) = 1;
    newleaves{i} = im_rec;
end

h = figure
for i = 1:4
    subplot(2,4,i);
    imshow(leaves{i});
    subplot(2,4,i+4);
    imshow(newleaves{i});
    
end

%% First 3 components of decimated
keeps = [1,2,3];
img = leaves{4}
boundaries = bwboundaries(img,8);
length(boundaries{1})
h = figure;

for i=1:length(keeps)
    % Decimate
    recovered_boundaries = jpr_fourier_decimate(boundaries{1},keeps(i));
    
    % Store the new boundary as an image
    idx = sub2ind(size(img), recovered_boundaries(:,1), recovered_boundaries(:,2));
    length(idx)
    im_rec= zeros(size(img));
    im_rec(idx) = 1;
  subplot(1,length(keeps),i)
  imshow(im_rec);
end
% saveas(h, 'leaf4_first3.pdf');   



