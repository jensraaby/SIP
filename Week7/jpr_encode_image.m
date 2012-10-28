function [ C_out,S_out ] = jpr_encode_image( inputimg, levels )
%ENCODE_IMAGE Summary of this function goes here
    
    % Stage 1: mapping
    % Stage 2: quantizing
    % Stage 3: symbol coding 

    % Check the entropy
    entropy = jpr_entropy(inputimg)
    
    % Get the dimensions
    [W,H] = size(inputimg)
    
%     % a few stats
%     theoretic_bits = W*H*8
%     entropy_bits = W*H*entropy
%     C = theoretic_bits/entropy_bits

    if nargin < 2
        levels = 4;
    end
    
    % FWT of input image
    wname = 'bior4.4'; % should be orthogonal or bi-orthogonal
    dwtmode('per'); % reduce annoying edge effects
    
    % level shift (so centred on zero)
    x = double(inputimg) - 128;
    [C,S] = wavedec2(x,levels,wname);
    
    % We now want to remove redundancy from the coefficients
    C_signs = sign(C);
    % set all zero'ed elements to be positive
    C_signs(C_signs == 0) = 1;
    
    % now get unsigned coefficients
    C_unsigned = abs(C);
    
    % Quantize step
    q_mu  = 0; % 0 for lossless
    q_eps = 0; % bits fo epsilon
    
    
    [thr,sorh,keepapp] = ddencmp('cmp','wv',inputimg)
    % compress the wavelet coefficients with hard thresholding
    thr = 20;
    [~,C_compressed,S_compressed,PERF0,PERFL2] = wdencmp('gbl',C,S,wname,levels,thr,sorh,keepapp);

    % add back the signs
    C_signed = C_compressed(:).*C_signs(:);
    
    
%     
%     % Wavelet decomposition of x. 
% n = 5; w = 'sym2'; 
% [c,l] = wavedec2(x,n,w);
% 
% % Wavelet coefficients thresholding. 
% thr=20;
% [xd,cxd,lxd,perf0,perfl2] = ... 
% wdencmp('gbl',c,l,w,n,thr,'h',1);
%     for s=1:levels
%         % apply quantization at scale s
%         
%         qi = 3*s - 2;
%         
%         % 1. get the coeffs
%         [cH,cV,cD] = detcoef2('all',C_unsigned,S,s);
%         % 2. quantize
%         cH_q = cH/q(qi);
%         cV_q = cV/q(qi+1);
%         cD_q = cD/q(qi+2);
%         
%     end
    
    C_out = C_compressed;
    S_out = S_compressed;
end

