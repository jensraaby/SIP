function hsi_image = RGBtoHSI( rgb_image )
%RGBTOHSI Converts a given image in RGB to HSI representation

[M N P] = size(rgb_image);
hsi_image = zeros(M, N, P);

% faster way : reshape image into 3 x (M*N) vector
% for each pixel, work out the hue, saturation and intensity
    for x=1:M
        for y = 1:N
            R = double(rgb_image(x,y,1));
            G = double(rgb_image(x,y,2));
            B = double(rgb_image(x,y,3));
            hsi_image(x,y,1) = hue(R,G,B);
            hsi_image(x,y,2) = saturation(R,G,B);
            hsi_image(x,y,3) = intensity(R,G,B);
        end
    end

end

function H = hue(R,G,B)
    numerator = 0.5 * (2*R - G - B);
    denominator = sqrt(R^2 + B^2 + G^2 - (R*G) - (R*B) - (B*G)); 
    theta = acos(numerator/denominator);
    
    if B<=G
        H = theta;
    else 
        H = 360 - theta;
    end
end

function S = saturation(R,G,B)
    S = (R+G+B - 3*min([R,G,B]))/(R+G+B);
end

function I = intensity(R,G,B)
    I = (R+G+B)/3;
end