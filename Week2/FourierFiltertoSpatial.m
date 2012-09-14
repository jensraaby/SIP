function [ spatial ] = FourierFiltertoSpatial( filterFourier )
%FOURIERFILTERTOSPATIAL Returns inverse Fourier transform of given filter
    spatial = real(ifft2(filterFourier));

end

