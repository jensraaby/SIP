function J = rangetransform(I, R1, R2)
%RANGETRANSFORM Transforms intensities of image I to range R1 to R2
%   produces and image J by mapping linearly intensities from image I to
%   range [R1, R2]
    
    I = cast(I,'int8');
    minI = min(min(I));
    maxI = max(max(I));
    rangeI = cast(maxI-minI,'double')
    
    
    rangeJ = cast(R2-R1,'double')
  
    scale = rangeJ/rangeI

    
    J = (I - minI) * scale + R1;
    

   
end

