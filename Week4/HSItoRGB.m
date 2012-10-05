function rgb_image = HSItoRGB( hsi_image )
%HSItoRGB Converts a given image in HSI to RGB representation

    [M N P] = size(hsi_image);
    n = numel(hsi_image)/P;

    % separate the channels and convert to normalised double:
    if P==3
        H = (hsi_image(:,:,1));
        S = (hsi_image(:,:,2));
        I = (hsi_image(:,:,3));
    end

    % for each channel, vectorise
    H_v = reshape(H,1,n) * 2 * pi;
    S_v = reshape(S,1,n);
    I_v = reshape(I,1,n);


    % apply the formulae from the slides
    
    % divide the pixels by hue
    sub120 = find(H_v<2*pi/3);
    sub240 = find(H_v>=2*pi/3 & H_v<4*pi/3);
    rest   = find(H_v>=4*pi/3 & H_v<2*pi);

    % handle each case of hue
    B(sub120) = I_v(sub120).*(1-S_v(sub120));
    R(sub120) = I_v(sub120).*(1+((S_v(sub120).*cos(H_v(sub120))./cos(pi/3-H_v(sub120)))));
    G(sub120) = 3*I_v(sub120) - R(sub120) - B(sub120);

    H_v(sub240) = H_v(sub240) - 2*pi/3;
    R(sub240) = I_v(sub240).*(1-(S_v(sub240)));
    G(sub240) = I_v(sub240).*(1+((S_v(sub240).*cos(H_v(sub240)))./cos(pi/3-H_v(sub240))));
    B(sub240) = 3*I_v(sub240) - R(sub240) - G(sub240);

    H_v(rest) = H_v(rest) - 4*pi/3;
    G(rest) = I_v(rest).*(1-S_v(rest));
    B(rest) = I_v(rest).*(1+((S_v(rest).*cos(H_v(rest)))./cos(pi/3-H_v(rest))));
    R(rest) = 3*I_v(rest) - B(rest) - G(rest);

    %reassemble image
    rgb_image(:,:,1) = reshape(R,M,N);
    rgb_image(:,:,2) = reshape(G,M,N);
    rgb_image(:,:,3) = reshape(B,M,N);

    