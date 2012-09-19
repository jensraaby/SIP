%In figure sky.jpg, assume that one has imaged the night sky by using a long exposure time.

sky = imread('sky.tif');
imshow(sky);
%http://www.sweaglesw.com/cs448/
%(a) Explain the source of the sky image degradation. 
%     Is the process linear? Is it shift invariant?

%(b) Estimate the location of the pole (close to Polaris) in pixels, 
%      and estimate the exposure time.

%(c) If you assumed that you would minimise the Tikhonov regularised least
%    squares error on the given image plane, why would it be it problematic 
%   to implement the inverse filtering solution in the Fourier domain?

%(d) How could you use the Fourier domain solution for Wiener filtering 
%     to recover the (instantaneous) night sky? Discuss what assumptions 
%     such a solution has and in which case it is optimal.