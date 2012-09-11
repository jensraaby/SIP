function [ outputimage ] = boxFilter( inputimage, n )
%BOXFILTER Performs box-filtering on image in spatial domain

    if n < 1
        error('n must be greater than 0')
    end
    M = 2*n +1;
    N = M;
    
    scalefactor = 1/(N*M);
    
    [x,y] = size(inputimage);
    
    % deal with padding around the image
    padded = zeros(x+M-1,y+M-1);
    
    % copy the input into the padded version
    for i=1:x
        for j=1:y
        padded(i+1,j+1) = inputimage(i,j);
        end
    end
    
    w = scalefactor * ones(M,N);
    
    for i=1:x
        for j=1:y
            padded(i,j) = padded(i,j) * w(1,1) + padded(i+1,j)*w(2,1) + padded(i+2,j) * w(3,1)...
                + padded(i,j+1) * w(1,2) + padded(i+1,j+1) * w(2,2) + padded(i+2,j+1) * w(3,2)...
                + padded(i,j+2) * w(1,3) + padded(i+1,j+2) * w(2,3) + padded(i+2,j+2) * w(3,3);

        end
    end
    
    outputimage = padded(2:x+2,2:y+2);
end

