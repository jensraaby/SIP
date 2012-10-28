function error = meansquarederror(origimg,newimg,scale)
if nargin <3
    scale = 1;
end
    D = (double(newimg)-double(origimg)).^2;
    
    error = (sum(D(:))/numel(newimg));
    rms_error = sqrt(error);
    
    if rms_error
        error_m = max(abs(D(:)));
        [h,x] = hist(D,error_m);
        if length(h) >= 1
            figure,bar(x,h,'k');
            emax = error_m/scale;
            e = mat2gray(D,[-emax,emax]);
            figure,imshow(e);
        end
    end
        
    