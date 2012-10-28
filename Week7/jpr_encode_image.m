% SIP Exercise 7
% Jens Raaby, October 2012

function [ compressed ] = jpr_encode_image( inputimg, levels, T, thresh, wname )
%ENCODE_IMAGE Encode the supplied image. Supply wavelet name in WNAME,
%number of wavelet levels in LEVELS, detail suppression threshold in
%THRESH, and the quantization bin size in T
    

    % Get the original dimensions
    [W,H] = size(inputimg);
    
    % Print a few stats to the command line
    entropy = jpr_entropy(inputimg)
    theoretic_bits = W*H*8
    entropy_bits = W*H*entropy
    C = theoretic_bits/entropy_bits

    % default values - quite high compression
    if nargin < 2
        levels = 4;
        T = 5;
    end
    
    % Wavelet settings
    if nargin < 5
        wname = 'bior4.4'; % should be orthogonal or bi-orthogonal
    end
    dwtmode('per'); % reduce annoying edge effects
    
    % Convert image to double and create wavelet decomposition
    img = double(inputimg);
    [C,S] = wavedec2(img,levels,wname);


    % We now want to remove redundancy from the coefficients

   
    % Set the threshold for suppressing detail coefficients
    if nargin > 3
        % manual threshold
        thr = thresh;
    else
        [thr,~,~] = ddencmp('cmp','wv',inputimg);
    end
    if thr == 0 % disable thresholding
        C_compressed = C;
        S_compressed = S;
    else
        % compress the wavelet coefficients with hard thresholding
        [~,C_compressed,S_compressed,~,~] = wdencmp('gbl',C,S,wname,levels,thr,'h',1);
    end
    
    
    if T ~= 0 
        % Quantize the coefficients   
        % T is the supplied quantisation parameter
        I = find(abs(C_compressed)<T);
        q = floor(abs(C_compressed)/T);

        C_quantized = sign(C_compressed).*(q+0.5)*T;
        C_quantized(I) = 0;
    else
        C_quantized = C_compressed;
    end
    % Gather the output variables:
    C_out = C_quantized;
    S_out = S_compressed;
    
    % Remove the coefficients with value zero and store their indices
    C_idx = find(C_out);
    C_vals = C_out(C_idx);
            
    % create a structure
%     compressed = struct('C',C_out,'S',S_out,'wname',wname);
    compressed = struct(...
        'C_idx',C_idx,...
        'C_vals',C_vals,...
        'C_size',size(C_quantized),...
        'S',S_out,...
        'wname',wname,'Width',W,'Height',H);
end

