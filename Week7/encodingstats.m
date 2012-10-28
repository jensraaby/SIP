function [ compression ] = encodingstats( originalimg, encodedimg )
%ENCODINGSTATS Compares original and encoded images

    orig_stats = whos('originalimg');
    origsize = orig_stats.bytes
    
    new_stats = whos('encodedimg');
    newsize = new_stats.bytes


    compression = origsize/newsize;
end

