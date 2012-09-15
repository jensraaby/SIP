function [LowPass] = LPfilter(radius,P,Q)
%LPFILTER A quick and dirty Low Pass filter (frequency domain)
% p and q are the dimensions of the filter.
% the cut off frequency is half the maximum frequency.

    LowPass = zeros(P,Q);
    for i=1:P
        for j = 1:Q
            d_ij = sqrt((i-(P/2))^2+(j-(Q/2))^2);

            if (d_ij <= radius)
                LowPass(i,j) = 1;
            else
                LowPass(i,j) = 0;
            end
        end
    end
    
    
end

