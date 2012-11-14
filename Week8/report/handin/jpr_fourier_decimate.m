function [ reconstructed_boundary ] = jpr_fourier_decimate( boundary, keep )
%JPR_FOURIER_DECIMATE Computes Fourier description of black and white
% boundary BOUNDARY and decimates the result to keep KEEP frequencies.  
% Returns reconstructed boundary points

    % Get length of boundary
    n = length(boundary);

    % Store all boundary points as complex numbers
    s = complex(boundary(:,1),boundary(:,2));

    % if odd number of points, make it even (so fourier transform does not duplicate a point)
    if mod(length(s),2) ~= 0
        
        if (keep ~= 1 && keep ~= 3) % but, we need odd numbers to keep DC/first3, so only do it in other cases
            s(end+1) = s(end);
        end
    end
    
    
    
    % Fourier transform and then centre the points
    F = fft(s);
    F_cent = fftshift(F);
    % nb. shift so that the high frequencies are at the ends rather than in
    % the centre of the vector


 
    % Decimate the results by removing the higher frequencies

    % work out how many points to decimate at each end of the vector:    
    r = round((n - keep)/2);
    % suppress the first r and last r values
    F_cent(1:r) = 0;
    F_cent(n-r+1:n) = 0;
    
    % Print some information
   fprintf('keep % d components :: removing %d. remaining: %d \n', keep,r,length(find(F_cent)));



    % inverse centre and transform
    F_decimated_decentred = ifftshift(F_cent);
    s_decimated = ifft(F_decimated_decentred);

    % recover the coordinates
    rows = real(s_decimated);
    cols = imag(s_decimated);

    % convert them back to integers (can't use doubles as coordinates)
    rows = round(rows);
    cols = round(cols);

    % ensure all indices are >0
    rows(rows<1) = 1;
    cols(cols<1) = 1;


    reconstructed_boundary = [rows cols];
end

