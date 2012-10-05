function hsi_image = RGBtoHSI( rgb_image )
%RGBTOHSI Converts a given image in RGB to HSI representation

    [M N P] = size(rgb_image);
    n = numel(rgb_image)/P;
    hsi_image = zeros(M, N, 3);

    % separate the channels and convert to normalised double:
    if P==3
        R = im2double(rgb_image(:,:,1));
        G = im2double(rgb_image(:,:,2));
        B = im2double(rgb_image(:,:,3));
    end


    % for each channel, vectorise
    R_v = reshape(R,1,n);
    G_v = reshape(G,1,n);
    B_v = reshape(B,1,n);

    summed = R_v + G_v + B_v;
    i = summed/3;
    I = reshape(i,M,N);

    s = 3*min([R_v; G_v; B_v],[],1);
    s = s./(summed+eps); % eps to avoid divide by zero
    s = 1 - s;
    S = reshape(s,M,N);


    
    h = 0.5*((R_v - G_v) + (R_v - B_v));
    denom = (R_v-G_v).^2 + (R_v-B_v).*(G_v-B_v)+eps; %from textbook, eps to avoid divide by zero
    h = h./(sqrt(denom));
    h = acos(h);
    
    % handle the 360 (2*pi) subtraction using the bigger indices:
    bigger = find(B_v>G_v);
    h(bigger) = 2*pi - h(bigger);
    h = h/(2*pi);
    
    H = reshape(h,M,N);



    hsi_image(:,:,1) = H;
    hsi_image(:,:,2) = S;
    hsi_image(:,:,3) = I;