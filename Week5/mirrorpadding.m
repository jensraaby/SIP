function [ mirimg, Fmirimg ] = mirrorpadding( img )
%MIRRORPADDING Creates a version of the image with reflection padding
%   RETURNS MIRIMG and fourier transform FMIRIMG
    [M N] = size(img);

    img = im2double(img);
    Mirrored = zeros(2*M,2*N);
    
    Mirrored(1:M,       1:N)     = img;
    Mirrored(1:M,       N+1:2*N) = fliplr(img);
    Mirrored(M+1:M*2,   1:N)     = flipud(img);
    Mirrored(M+1:M*2    ,N+1:2*N)= fliplr(flipud(img));
  

    mirimg = Mirrored;
    Fmirimg= (fft2(Mirrored));

end

