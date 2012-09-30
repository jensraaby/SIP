function [s,ps] = transformQ3(image)

    g = @(r) 0.5*(1+cos(2*pi()*r));
    image = im2double(image);
    s = g(image);
    
    %compare to ps
    s2 = min(image):0.001:max(image);
    for k=1:length(s2)
        ps(k) = 2/(2*pi()*sqrt(-(s2(k)-1)*s2(k)));
    end    
%     hist(ps,1000);
end


