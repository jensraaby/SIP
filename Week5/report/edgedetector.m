% Jens Raaby, SIP Ex 5.1
function [ edgeimg ] = edgedetector( img, sigma, sigmay, threshold, detectiontype )
%EDGEDETECTOR Summary of this function goes here
%   IMG - image with mirror padding
%   SIGMA - used for Gaussian. 
%   SIGMAY - optional, applies to rows only
%   THRESHOLD - optional, determines cutoff for grandient magnitude
%   TYPE - optional, should be 'basic' or 'marr-hildreth'

    if nargin<2
        sigma = 1; % default
        sigmay = sigma;
    elseif nargin == 2
        sigmay = sigma;
    end
    
    if nargin < 4
        threshold = 0.5;
    elseif nargin < 5
        detectiontype = 'basic';
    end
    
    % Get the size (assumes it is mirror padded!!);
    [M,N] = size(img);
    
    if strcmp(detectiontype,'basic')
       
        % Do scale in the Fourier domain
        I = (fft2(img));

        Ix = scale(I,sigma,0,1);  % 0 1 first order x (vertical lines)
        Iy = scale(I,sigmay,1,0); % 1 0 first order y (horizontal lines)

        % Inverse transform
        ix  = ifft2(Ix);
        iy  = ifft2(Iy);
        ix = ix(1:M/2,1:N/2);
        iy = iy(1:M/2,1:N/2);
        ixy = abs(ix) + abs(iy);

        % determine edges by threshold
        top = max(max(ixy));
        cutoff = threshold * top;
        edgeimg = ixy;
        edgeimg(ixy>cutoff) = 1;
        edgeimg(ixy<=cutoff)= 0;
        
    elseif strcmp(detectiontype,'marr-hildreth')
        
        rows = 2:M/2-1; % original size without initial/final pixel, unpadded
        cols = 2:N/2-1; % -----ditto--------
        
        % use scale to apply Gaussian blur and find second derivative
        I = (fft2(img));
        Ixx = scale(I,sigma,0,2);
        Iyy = scale(I,sigmay,2,0);

        ixx = ifft2(Ixx);
        iyy = ifft2(Iyy);
        gradient_sum = ixx + iyy;
        magnitude = sqrt(ixx.*ixx+iyy.*iyy);
  
        edgeimg = zeros(M/2,N/2);
        
        % find the horizontal zero crossings (sign change)
        colrange = [cols-1; cols+1];
        rowrange = [rows-1; rows+1];
        rowlength=M/2;
        
        % decreasing from left to right
        [edgerows,edgecols] = find( gradient_sum(rows,colrange(1,:)) > 0 & ...
                                    gradient_sum(rows,cols) < 0 & ...
                                    abs( gradient_sum(rows,colrange(1,:))-gradient_sum(rows,cols) ) > threshold ); 
        edgeimg((edgerows+1) + (edgecols*rowlength)) = 1;
        
        % increasing from left to right
        [edgerows,edgecols] = find( gradient_sum(rows,cols) < 0 & ...
                                    gradient_sum(rows,colrange(2,:)) > 0 & ...
                                    abs(gradient_sum(rows,cols)-gradient_sum(rows,colrange(2,:))) > threshold ); 
        edgeimg((edgerows+1) + (edgecols*rowlength)) = 1;
        
        % find vertical zero crossings
        % increasing from top to bottom
        [edgerows,edgecols] = find( gradient_sum(rows,cols) < 0 & ...
                                    gradient_sum(rowrange(2,:),cols) > 0 & ...
                                    abs(gradient_sum(rows,cols)-gradient_sum(rowrange(2,:),cols)) > threshold ); 
        edgeimg((edgerows+1) + (edgecols*rowlength)) = 1;
        % decreasing from top to bottom
        [edgerows,edgecols] = find( gradient_sum(rowrange(1,:),cols) > 0 & ...
                                    gradient_sum(rows,cols) < 0 & ...
                                    abs(gradient_sum(rowrange(1,:),cols)-gradient_sum(rows,cols) ) > threshold ); 
        edgeimg((edgerows+1) + (edgecols*rowlength)) = 1;
        
    end

end

