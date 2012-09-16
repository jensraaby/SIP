function [ spectrum ] = imageSpectrum( image )
%IMAGESPECTRUM Computes the Fourier transform of IMAGE and returns a
%spectrum which can be displayed.

    [X,Y] = size(image);
    
% Create a zero-padded version of the images
    f_padded                    = zeros(X*2,Y*2);
    f_padded(1:X,1:Y)           = image;
    
    % Compute the Discrete Fourier Transform of the padded image:
    F_orig = fft2(f_padded);
    
    spectrum = real(fftshift(F_orig));
    
    
end

