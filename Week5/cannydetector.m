% Jens Raaby, SIP Ex 5.2
function [edges] = cannydetector(img,thresh_h,thresh_l,sigma)

    [M, N] = size(img);
    edges = zeros(M,N);
    
    % Mirror padding
    [~,Fmir] = mirrorpadding(img);
    
    % Compute Derivatives with Scale :
    Dx = scale(Fmir,sigma,0,1);
    Dy = scale(Fmir,sigma,1,0);
    dx = ifft2(Dx);
    dy = ifft2(Dy);
    % We only need to think about the unpadded image
    dx = dx(1:M,1:N);
    dy = dy(1:M,1:N);
    
    % Compute directions for all pixels
    direction = atan((dy)./(dx))*180/pi; % in degrees (can be pos or neg

    % Compute magnitude
    magnitude = sqrt(dx.*dx + dy.*dy); % = hypot(dx,dy); better syntax

    % normalise the magnitudes
    if max(magnitude(:)) ~= 0
        magnitude = magnitude/max(magnitude(:));
    end
    
    % perform non-maxima suppression (the slow bit):
    [maxima,directionlabels] = nms(magnitude,direction);

    % Thresholding
    %   from Gonzalez and Woods p 722:
    g_NH = zeros(M,N); % strong
    g_NL = zeros(M,N); % weak

    g_NH(maxima>=thresh_h) = 1; % strong
    g_NL(maxima>=thresh_l)  = 1; % weak+strong
    g_NL = g_NL-g_NH;  % weak
    [cols,rows] = find(g_NH);
    
    % now incorporate the weak edges adjacent to the strong ones
    edges = connectivity(g_NH,g_NL,directionlabels);
%     edges = g_NH + bwselect(g_NL,cols,rows,8);

    
    
    
   
function longerEdges = connectivity(strong,weak,directions) 
   % function to strengthen strong edges with neighbouring weak edges
        newstrong = zeros(size(strong));
        [M,N] = size(strong);
        for x=2:M-1
            for y=2:N-1
                if (strong(x,y) == 1) % edge pixel - if any neighbours are weak edges, make them strong
                    dir_strong = directions(x,y);
                    if weak(x-1,y-1)==1 && directions(x-1,y-1) == dir_strong
                        newstrong(x-1,y-1)   = 1;
                    end
                    if weak(x-1,y)==1 && directions(x-1,y) == dir_strong
                        newstrong(x-1,y)     = 1;
                    end
                    if weak(x-1,y+1)==1 && directions(x-1,y+1) == dir_strong
                        newstrong(x-1,y+1)   = 1;
                    end
                    if weak(x,y-1)==1 && directions(x,y-1) == dir_strong
                        newstrong(x,y-1)     = 1;
                    end
                    if weak(x,y+1)==1 && directions(x,y+1) == dir_strong
                        newstrong(x,y+1)     = 1;
                    end
                    if weak(x+1,y-1)==1 && directions(x+1,y-1) == dir_strong
                        newstrong(x+1,y-1)   = 1;
                    end
                    if weak(x+1,y)==1 && directions(x+1,y) == dir_strong
                        newstrong(x+1,y)     = 1;
                    end
                    if weak(x+1,y+1)==1 && directions(x+1,y+1) == dir_strong
                        newstrong(x+1,y+1)   = 1;
                    end
                end
            end
        end
        longerEdges = newstrong+strong;

    


function [gradientMaxima,directionLabels] = nms(magnitude,direction)
%NMS - Gets gradient maxima and direction labels for all pixels
% magnitude= M*N array of gradient magnitudes
% direction= M*N array of gradient angles in degrees
    gradientMaxima = zeros(size(magnitude));
    directionLabels = zeros(size(magnitude));
    [M,N] = size(magnitude);
    
    % find the indices of all the 4 directions (of a 3x3 neighbourhood)
    dir{1} = find(-22.5 < direction & direction <= 22.5); %horizontal
    dir{1} = [dir{1}; find(-157.5 > direction & direction >= -202.5)];

    dir{2} = find(22.5 < direction & direction <= 67.5); %diag 1
    dir{2} = [dir{2}; find(-112.5 > direction & direction >= -157.5)];

    dir{3} = find(67.5 < direction & direction <= 112.5); %vertical
    dir{3} = [dir{3}; find(-67.5 > direction & direction >= -112.5)];

    dir{4} = find(112.5 < direction & direction <= 157.5); %diag 2
    dir{4} = [dir{4}; find(-22.5 > direction & direction >= -67.5)];

    directionLabels(dir{1}) = 1;
    directionLabels(dir{2}) = 2;
    directionLabels(dir{3}) = 3;
    directionLabels(dir{4}) = 4;

    % horrible slow loop
    for n=1:numel(gradientMaxima)
        n_dir = directionLabels(n);

        % get neighbour indices
        switch n_dir
            case 1 %north south
                first  = n-M;
                second = n+M;

            case 2 % 45 tl to br
                first  = n-M-1;
                second = n+M+1;   

            case 3 %east west
                first  = n-1;
                second = n+1;     

            case 4 % 45 bl to tr
                first  = n-M+1;
                second = n+M-1;

        end

        % correct edge conditions
        if n<=M % first row
            first = first+M;
        end
        if mod(n,M)==1 %first column
            first = first+1;
        end
        if mod(n,M)==0 % last col
            second = second-1;
        end
        if n>(N-1)*M % last row
            second = n;
        end
        fstDir = directionLabels(first);
        sndDir = directionLabels(second);

        % make a vector of the neighbour-edge magnitudes
        mags = [magnitude(n)];

        if ( fstDir == n_dir )
            mags = [mags magnitude(first)];
        end
        if ( sndDir == n_dir)
            mags = [mags , magnitude(second)];
        end

        % suppress if the current value is not the maximum
        maxmag = max(mags);
        if magnitude(n) < maxmag
            gradientMaxima(n) = 0;
        else
            gradientMaxima(n) = maxmag;
        end
    end
