function [ filteredImage, figureHandle ] = filteringPackage( image, fourierFilter )
%FILTER Summary of this function goes here
%   Detailed explanation goes here

    % Process the input image:
    original = mat2gray(image);
    [M N] = size(original);
    
    % padding dimensions
    P = 2*M;
    Q = 2*N;
    
    % Create a padded version of the original image
    padded = zeros(P,Q);
    padded(1:M,1:N) = original;
    
    % Computer Discrete Fourier Transform of image:
    F_uv = fft2(padded);
    
    % The filter should match the size of the padded image
    % In this step, the spatial filter is transformed to the frequency
    % domain, padded to the same size as the image, and shifted
%     H_uv = fftshift(fft2(spatialFilter,P,Q));
    H_uv = fourierFilter;
    % Perform the matrix multiplication of the filter with the (shifted) image
    G_uv = H_uv .* fftshift(F_uv);
   
    % Convert the Fourier domain image to the spatial domain
    filteredImage = real(ifft2(G_uv));


    figureHandle = figure;
    % image, filter and filtering result in fequency and spatial domain
    subplot(2,3,1);
    imshow(log(1+abs(fftshift(F_uv))),[]);
    title('Fourier image');
    subplot(2,3,2);
    imshow(real(H_uv));
    title('Fourier filter');
    subplot(2,3,3);
    imshow(log(1+abs((G_uv))),[]);
    title('Filtered image (Fourier)');

    subplot(2,3,4);
    imshow(padded);
    title('Spatial image');
    subplot(2,3,5);
    imshow(real(ifft2(H_uv)));
    title('Spatial filter');
    subplot(2,3,6);
    imshow(filteredImage);
    title('Processed image (spatial domain)');

    
end


