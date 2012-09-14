image = imread('barbara.tif');
[M N] = size(image);
P=M*2;
Q=N*2;

lpFourier = LPfilter(50,P,Q);
% lpSpatial = FourierFiltertoSpatial(lpFourier);

FivebyFiveaveraging = 1/25 * ones(5,5);
FivebyFiveFourier = fft2(FivebyFiveaveraging,P,Q);
filteringPackage(image,FivebyFiveFourier);

% %Implement a 2-D filtering program ?package? that makes the filtering in 
% %the Fourier domain, given either the impulse response of the filter in the
% % spatial domain, or the transfer function in the Fourier domain. 
% 
% % You may use the MATLAB implementation of the FFT (and fftshift, ifftshift) 
% % and but other parts of the programme you should program yourself 
% % (not to use functions from the image processing toolbox). 
% 
% % Your implementation must have the capabilities to:
% %(a) Extend the image and the filter by zero padding to avoid wrap around error.
% %(b) Performing the filtering in the Fourier domain.
% %(c) Visualise the image, the filter, and the filtering result, in both 
% % spatial and Fourier domain, so that the the frequency response is centred on the Fourier domain.
% 
% %Test the implementation, by filtering the given test image testimg.tif 
% % by 5 × 5 averaging filter, and the ideal low pass filter, and 
% % compare the results. Explain what you did and the results you obtained.
% 
% inputimg = 'testimg.tif';
% original = imread(inputimg);
% original = mat2gray(original);
% % the input filter is the impulse response or the transfer function
% [M N] = size(original);
% %padding dimension
% P = 2*M;
% Q = 2*N;
% padded = zeros(P,Q);
% padded(1:M,1:N) = original;
% % Computer DFT of image, padded to fit PxQ:
% F_uv = fft2(padded);
% 
% % Averaging filter
% n = 10;
% h_average = 1/(n^2) * ones(n,n);
% % DFT of the filter
% H_average = fftshift(fft2(h_average,P,Q));
% 
% 
% % Generate Frequency domain LowPass filter function
% H_uv = ones(P,Q);
% % H_uv(P/2,Q/2) = 0;
% radius = 100;
% for i=1:P
%     for j = 1:Q
%         d_ij = sqrt((i-(P/2))^2+(j-(Q/2))^2);
%         
%         if (d_ij <= radius)
%             H_uv(i,j) = 1;
%         else
%             H_uv(i,j) = 0;
%         end
%     end
% end
% 
% 
% 
% 
% G_uv = H_average .* fftshift(F_uv);
% % get processed image
% processed = real(ifft2(G_uv));
% % for i=1:P
% %     for j=1:Q
% %         processed(i,j) = processed(i,j); %* (-1)^(i+j);
% %     end
% % end
% 
% f1 = figure;
% % image, filter and filtering result in fequency and spatial domain
% subplot(2,3,1);
% imshow(log(1+abs(fftshift(F_uv))),[]);
% title('Fourier image');
% subplot(2,3,2);
% imshow(H_average);
% title('Fourier filter');
% subplot(2,3,3);
% imshow(log(1+abs((G_uv))),[]);
% title('Filtered image (Fourier)');
% 
% subplot(2,3,4);
% imshow(padded);
% title('Spatial image');
% subplot(2,3,5);
% imshow(ifft2(H_average));
% title('Spatial filter');
% subplot(2,3,6);
% imshow(processed);
% title('Processed image (spatial domain)');
% 
