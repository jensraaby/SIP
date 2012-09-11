function [ outputimage ] = spatialFilter( inputimage, w )
%SPATIALFILTER Applies a 3x3 filter w to an input image 

    %check w size
    [m,n] = size(w);
    if ([m,n] ~= [3,3]) 
        error('Bad filter size'); 
    end;
    [x,y] = size(inputimage);

    padded = zeros(x+2,y+2);
    
    for i=1:x
        for j=1:y
        padded(i+1,j+1) = inputimage(i,j);
        end
    end

% now apply the filter to the padded image:
    for i=1:x
        for j=1:y
            padded(i,j) = padded(i,j) * w(1,1) + padded(i+1,j)*w(2,1) + padded(i+2,j) * w(3,1)...
                + padded(i,j+1) * w(1,2) + padded(i+1,j+1) * w(2,2) + padded(i+2,j+1) * w(3,2)...
                + padded(i,j+2) * w(1,3) + padded(i+1,j+2) * w(2,3) + padded(i+2,j+2) * w(3,3);

        end
    end
    
    outputimage = padded(2:x+2,2:y+2);
end

