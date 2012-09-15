function [ H_lp ] = gaussianLowPass( P,Q,D0 )
%GAUSSIANLOWPASS Returns Gaussian low pass filter of size P x Q, with
%cutoff frequency D0.

    H_lp = zeros(P,Q);
    centrex = round(P/2);
    centrey = round(Q/2);
    
    for x=1:P
        for y=1:Q
            % squared distance from centre
            d_tmp = (x - centrex).^2 + (y - centrey).^2;
            % note D0 used for sigma, as in GW section 4.8.3
            H_lp(x,y) = exp(-d_tmp / 2 / D0 / D0);
        end
    end
end

