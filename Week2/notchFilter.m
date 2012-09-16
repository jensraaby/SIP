function H_notch = notchFilter( P,Q, cutoff, x, y )
%NOTCHFILTER Creates a notch filter in the frequency domain.
%   Cutoff is the frequency to cut off.
%   X and Y are the centre coordinates for the notch in the Fourier spectrum

    % The notch is a product of a (Gaussian) high pass filter
    H_hp    = 1 - gaussianLowPass(P,Q,cutoff);
    
    % Centres the HP filter on down by y-1 and left by x-1
    H_notch = circshift(H_hp, [y-1 x-1]);

end

