function [ filteredImage ] = applyFilter( image, filter, filterType, visualise )
%APPLYFILTER This function applies the given filter to the given image
%   image - a matrix representing grayscale pixels
%   filterType - either 'spatial' or 'Fourier' (domain of the filter).
%   Default is Fourier
%   filter - the matrix representing the filter
%   visualise - determines whether the function shows a visual
%   representation of the filtering operation

error(nargchk(2, 4, nargin));  % Allow 2 to 4 inputs

    % Process the input image:
    original = im2double(image);
    [M N] = size(original);
    
    % padding dimensions
    P = 2*M; Q = 2*N;
    
    % Create a zero-padded version of the original image
    f_padded = zeros(P,Q);
    f_padded(1:M,1:N) = original;
    
    % Compute the Discrete Fourier Transform of the padded image:
    F = fft2(f_padded);
    
    
    % Handle the filter:
    if (nargin>2 && strcmp(filterType, 'spatial'))
        % Caller has specified spatial filter type
        % Need to transform to Fourier and ensure padded to size P x Q
        H = fftshift(fft2(filter,P,Q));
        
    else
        % Assume Fourier filter supplied
        H = filter;
       
        % Need to ensure the size of the filter and image match
        if (size(H) ~= size(F))
            error('Image and filter size must agree');
        end
       
        
    end
   
    % Perform the filtering
    G = H .* fftshift(F);

    % Convert the result back into the spatial domain
    g_padded = real(ifft2(double(G)));
    
    % Remove padding
    filteredImage = abs(g_padded(1:M, 1:N));

    % Visualisation:
    if (nargin>3)
       if (visualise)
           % Caller has requested visualisation
           
            % displays image, filter and filtering result in fequency and 
            % spatial domains
            subplot(2,3,1);
            imshow(log(1+abs(fftshift(F))),[]);
            title('Fourier image');

            subplot(2,3,2);
            imshow(real(H));
            title('Fourier filter');

            subplot(2,3,3);
            imshow(log(1+abs((G))),[]);
            title('Filtered image (Fourier)');

            subplot(2,3,4);
            imshow(original);
            title('Spatial image');

            subplot(2,3,5);
            imshow(abs(real(ifft2(H))));
            size(abs(real(ifft2(H))))
            title('Spatial filter');

            subplot(2,3,6);
            imshow(filteredImage);
            title('Processed image (spatial domain)');
       end
    end
end

