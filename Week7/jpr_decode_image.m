% SIP Exercise 7
% Jens Raaby, October 2012
function [ uncompressed ] = jpr_decode_image( compressed )
%JPR_DECODE_IMAGE Decompresses my encoded images

    % Get the compressed components
    W = compressed.Width;
    H = compressed.Height;
    
    %initialise coefficients to empty
    C_in = zeros(compressed.C_size);

    
    % load the non-zero coefficients
    C_idx = compressed.C_idx;
    C_vals = compressed.C_vals;

    C_in(C_idx) = C_vals;
   
    S_in = compressed.S;
    
    wname = compressed.wname;
    
    % set dwtmode
    dwtmode('per'); % reduce annoying edge effects
    
    % invert the wavelet transform:
    recovered = waverec2(C_in,S_in,wname);
    
    % cast to uint8
    uncompressed = cast(recovered,'uint8');
end

