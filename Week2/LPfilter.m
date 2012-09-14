function [LowPass] = LPfilter(radius,p,q)
%LPFILTER A quick and dirty Low Pass filter (frequency domain)
% p and q are the dimensions of the filter.
% the cut off frequency D0 is half the maximum frequency.
    D0 = radius;
    LowPass = zeros(p,q);
    for i=1:p
        for j = 1:q
            d_ij = sqrt((i-(p/2))^2+(j-(q/2))^2);

            if (d_ij <= D0)
                LowPass(i,j) = 1;
            else
                LowPass(i,j) = 0;
            end
        end
    end
    
end

