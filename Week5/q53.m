clear all
% Mandatory Assignment 5.3: Implement the double thresholding algorithm.
test = im2double(imread('Fig1039(a)(polymersomes).tif'));
lena = im2double(imread('Lena.tif'));
rice =im2double(imread('rice.tif'));
img = lena;
[M N] = size(img);
% % first implement iterative threshold finding loop:
% 1 Start with T = mean gray value of image.
% 2 Partition the image into R1 and R2 according to T
% 3 Compute mean values ?1 and ?2 of R1 and R2
% 4 Select new T = 1/2(?1 + ?2).
% 5 Repeat steps 2?4 until convergence.
vec = reshape(img,1,numel(img));
T_prev = mean(vec);
T = max(vec);
while T ~= T_prev
    T_prev = T;
    mu_1 = mean(vec(vec<T));
    mu_2 = mean(vec(vec>=T));
    T = 0.5 * (mu_1 + mu_2);
end
threshhold = img;
threshhold(img<T) = 0;
threshhold(img>=T) = 1;
%figure(1);
%imshow(threshhold);

% Select T1 by iterative algorithm. Set T2 = T1 + ? (? user-defined).
% 2 Compute Regions R1 , R2 , R3 :
%  a) R1: pixels with gray value ? T1
%  b) R2: pixels with gray value between T1 and T2 
%  c) R3: pixels with gray value above T2
% 3 Visit each pixel of R2 : if it has a neighbor in R1 , reassign to R1 .
% 4 repeat previous step until no pixel of R2 is reassigned.
% 5 assign all remaining pixels of R2 to R3.
epsilon = 0.02;
T1 = T;
T2 = T1 + epsilon;

R1 = find(img<=T1);
R2 = find(img>T1 & img<=T2);
R3 = find(img>T2);
[r1_rows,r1_cols] = find(img<=T1);
[r2_rows,r2_cols] = find(img>T1 & img<T2);
[r3_rows,r3_cols] = find(img>=T2);
%neighbour indexing
%(http://blogs.mathworks.com/steve/2007/03/28/neighbor-indexing/)
northidx = -1;
southidx =  1;
eastidx  =  M;
westidx  = -M;
% north_neighbours = img(R2 + northidx);
% south_neighbours = img(R2 + southidx);
% east_neighbours = img(R2 + eastidx);
% west_neighbours = img(R2 + westidx);
% imhist(img)
%%
sizeR2_prev = 1;
sizeR2 = length(R2);
k = sizeR2_prev;
% this is really slow!
% while sizeR2 ~= sizeR2_prev
   % find neighbours in R1
   R1img = zeros(size(img));
   R1img(R1) = 1;
   R2img = zeros(M,N);
   R2img(R2) = 1;
    R3img = zeros(M,N);
   R3img(R3) = 1;
   graythresh
   neighbours = bwselect(R1img,r2_cols,r2_rows,8);
% end
% while sizeR2 ~= sizeR2_prev && k<sizeR2
%     if (    ismember(R2(k)+1,R1) || ... % next element in R1?
%             ismember(R2(k)-1,R1) || ... % previous in R1?
%             ismember(R2(k)-M,R1) || ... % above in R1?
%             ismember(R2(k)+M,R1))       % below in R1?
%        R2 = R2(R2~=R2(k)); % remove from R2
%        R1 = [R1; R2(k)]; % add the element to R1
%        
%        sizeR2_prev = sizeR2;
%        sizeR2 = length(R2);
%        
%     else
%         k = k+1;
%     end
%        
% end
R3 = [R3; R2];

thresholded = img;
thresholded(R1) = 0;
thresholded(R2) = 0.5;
thresholded(R3) = 1;


%%
changedimg = img;
changedimg(R1) = 0;
changedimg(R2) = 0.5;
changedimg(R3) = 1;
R1neighbours = colfilt(changedimg,[3 3],'sliding',@min);
r2tmp = 1;
while length(R2) ~= r2tmp
% Find the min of the neighbourhood of all pixels (if 0, then one of them
% is in R1)
    
    r2tmp = length(R2);
    
    for k = 1:numel(R2)
        if k<=length(R2)
            if(R1neighbours(k) == 0)
                R1 = [R1;R2(k)];
                R2(k) = [];
            end
            changedimg(R1) = 0;
            changedimg(R2) = 0.5;
        else
            break
        end
        
    end
    R1neighbours = colfilt(changedimg,[3 3],'sliding',@min);
    
end
