function [ H ] = jpr_entropy( matrix )
%JPR_ENTROPY Work out the entropy of a matrix
    
    % defined from Gonzalez/Woods eq. 8.1.6
    
    % possible levels:
    J = 256;
    
    % convert matrix to double
    x = double(matrix);
    
    % Create J-binned histogram for probabilities
    h = hist(x(:), J);
    % convert to probability vector
    p = h/sum(h(:));
    
    % find elements which are not 0, as those don't work with log2
    nz = find(p);
    
    H = - sum(p(nz) .* log2(p(nz)));
    
end

