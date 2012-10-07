clear all
%Training exercise 5.2: Play with the Matlab implementation of the Canny edge detector. 
% Are there parameter values more satisfying than others?
% Mandatory assignment 5.2 Implement your own Canny edge detector (don?t use Matlab one!)

%  hedge = vision.EdgeDetector;
%  hcsc = vision.ColorSpaceConverter(...
%          'Conversion', 'RGB to intensity');
%  hidtypeconv = ...
%    vision.ImageDataTypeConverter('OutputDataType','single');
%  img = step(hcsc, imread('20120623-Sverige-_JPR9645.jpg'));
%  img1 = step(hidtypeconv, img);
%  edges = step(hedge, img1);
%  imshow(edges);

% img = imread('Fig1022(a)(building_original).tif');
img = imread('Lena.tif');
img = im2double(img);
[M, N] = size(img);
% Part one
% 1. smooth image (gaussian)
% 2. gradient computation (first deriv, combine with 1)
    %a magnitude = gradient > threshold
%    b direction = atan(abs(dy)/abs(dx))
[mir,Fmir] = mirrorpadding(img);
sigma = 1;
% Derivatives
Dx = scale(Fmir,sigma,0,1);
Dy = scale(Fmir,sigma,1,0);
dx = ifft2(Dx);
dy = ifft2(Dy);
% note we only need to think about the unpadded image
dx_ = dx(1:M,1:N);
dy_ = dy(1:M,1:N);
% imshow(dx_ + dy_);
directionrad = atan(abs(dy_)./abs(dx_));
directiondeg = directionrad*180/pi;
magnitude = abs(dx)+abs(dy);
%magnitude = sqrt(dx.*dx + dy.*dy);

% work out thresholds
maxmag = max(magnitude(:));
t_mag = .4*maxmag;

refined = magnitude;
refined(refined>t_mag)  = 1;
refined(refined<=t_mag) = 0;
% imshow(refined(1:M,1:N),[]);

%% 3. round gradient direction to nearest 45deg, determine 
directiondeg2 = zeros(size(directiondeg));
gradientDir = zeros(size(directiondeg2));
for a = 1:numel(directiondeg)
    ang = directiondeg(a);
    if ang >= -45/2 && ang <= 45/2
        newang = 0;
        direction = 1;% (horizontal edge)
        
    elseif ang > 45/2 && ang <=(90-45/2)
        newang = 45;
        direction = 2; % edge from 
        
    elseif ang > (90-45/2) && ang <=(90+45/2)
        newang = 90;
        direction = 3;
        
    elseif ang > (90+45/2) && ang <=(135+45/2)
        newang = 135;
        direction = 4;
        
    elseif ang > (135+45/2) && ang <=(180+45/2)
        newang = 180;
        direction = 1;
        
    elseif ang > (180+45/2) && ang <=(225+45/2)
        newang = 225;
        direction = 2;
        
    elseif ang > (225+45/2) && ang <=(270+45/2)
        newang = 270;
        direction = 3;
        
    elseif ang > (270+45/2) && ang <=(315+45/2)
        newang = 315;
        direction = 4;
        
    elseif ang > (315+45/2) && ang <=(360+45/2)
        newang = 360;
        direction = 1;
    end
    directiondeg2(a) = newang;
    gradientDir(a) = direction;
end


%%
% all pixels in this direction have their mag, rest have 0
magnitude = magnitude(1:M,1:N);

dir1_ = zeros(size(img));
index = find(gradientDir==1);
dir1_(index) = magnitude(index);

dir2_ = zeros(size(img));
index = find(gradientDir==2);
dir2_(index) = magnitude(index);

dir3_ = zeros(size(img));
index = find(gradientDir==3);
dir3_(index) = magnitude(index);

dir4_ = zeros(size(img));
index = find(gradientDir==4);
dir4_(index) = magnitude(index);

%line neighbours


% 4. compare magnitude of pixels with neighbour magnitudes in the same
% direction e.g. if 90 degrees (direction 1) look north and south
% 5. if magnitude of current pixel is largest, then keep it. else set to 0
g_N = zeros(M,N);
tic
for n=1:numel(img)
    
    direction = gradientDir(n);

    % get neighbour indices
    switch direction
        case 1 %north south
            first  = n-M;
            second = n+M;
            same = dir1_;
            
        case 2 % 45 tl to br
            first  = n-M-1;
            second = n+M+1;
            same = dir2_;
            
        case 3 %east west
            first  = n-1;
            second = n+1;
            same = dir3_;
            
        case 4 % 45 bl to tr
            first  = n-M+1;
            second = n+M-1;
            same = dir4_;
    end

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
    
    fstDir = gradientDir(first);
    sndDir = gradientDir(second);
    

    % make a vector of magnitudes
    mags = [magnitude(n)];
    
    if ( fstDir == direction )
        mags = [mags magnitude(first)];
    end
    if ( sndDir == direction)
        mags = [mags , magnitude(second)];
    end
    
    % suppress if the current pixel is not the maximum
    maxmag = max(mags);
    if magnitude(n) < maxmag
        g_N(n) = 0;
    else
        g_N(n) = maxmag;
    end
end
toc



%%
% 6. double threshold (mag<thigh = strong, tlow<mag<thigh = weak). rest set
% 0

t_high = 0.15;
t_low  = 0.4 * t_high;

g_NH = zeros(M,N);
g_NL = zeros(M,N);

g_NH(g_N>=t_high) = 1; 
g_NL(g_N>=t_low)  = 1;
% g_NL  = g_NL - g_NH;

%%
% 7. weak edges only included if connected to strong edges with other weak
% edges
[C,R] = find(g_NH);
%  C = rem(find(g_NH)-1,M) +1;
%  R = floor((find(g_NH)-1)/M)+1;
% 
% find the 8-connected weak edges
g_NL2 = bwselect(g_NL,C,R,8);
tic
toc
%%
g_NH2 = zeros(size(g_NH));
for x=2:M-1
    for y=2:N-1
        if (g_NH(x,y) == 0) % non-edge pixel - if any neighbours are weak edges, make them strong
            if g_NL(x-1,y-1)==1
                g_NH2(x-1,y-1)   = 1;
            end
            if g_NL(x-1,y)==1
                g_NH2(x-1,y)     = 1;
            end
            if g_NL(x-1,y+1)==1
                g_NH2(x-1,y+1)   = 1;
            end
            if g_NL(x,y-1)==1
                g_NH2(x,y-1)     = 1;
            end
            if g_NL(x,y+1)==1
                g_NH2(x,y+1)     = 1;
            end
            if g_NL(x+1,y-1)==1
                g_NH2(x+1,y-1)   = 1;
            end
            if g_NL(x+1,y)==1
                g_NH2(x+1,y)     = 1;
            end
            if g_NL(x+1,y+1)==1
                g_NH2(x+1,y+1)   = 1;
            end
%          if( g_NL(x-1,y-1)==1 | ...
%              g_NL(x-1,y)==1   | ...
%              g_NL(x-1,y+1)==1 | ...
%              g_NL(x,y-1)==1   |  ...
%              g_NL(x,y+1)==1   | ...
%              g_NL(x+1,y-1)==1 | ...
%              g_NL(x+1,y)==1   | ...
%              g_NL(x+1,y+1)==1 ) 
%              
%             g_NL2(x,y)=1;
%          end
        end
    end
end
g_NL = g_NH2;
toc

%% alternative matlab method
dir{1} = find( (dy_<=0 & dx_>-dy_)  ...
           | (dy_>=0 & dx_<-dy_)); % north/south
      
dir{2} = find( (dx_>0 & -dy_>=dx_)  ...
           | (dx_<0 & -dy_<=dx_)); % southeast/northwest
      
dir{3} = find( (dx_<=0 & dx_>dy_)  ...
           | (dx_>=0 & dx_<dy_)); % east/west
     
dir{4} = find( (dy_<0 & dx_<=dy_)  ...
           | (dy_>0 & dx_>=dy_)); % southwest/northeast 
  %%    
for n=2:(M-1)*N

    % Get current direction
    dir = gradientDir(n);
        
    % Get all the other pixels with same direction
%     allinthatdir = find(gradientDir==dir);
    % if allinthatdir contains neighbours of n, then do suppression
%     gy = dy_(allinthatdir);
%     gx = dx_(allinthatdir);
    
    % indices of neighbourhood
    left    = n-1;
    right   = n+1;
    tl      = n-M-1;
    above   = n-M;
    tr      = n-M+1;
    bl      = n+M-1;
    below   = n+M;
    br      = n+M+1;
    
    %handle border conditions (god this is ugly)
    if (mod(n,M)==0) % end of a row
        right = n;
        tr = n-M;
        br = n+M;
    end
    if (mod(n,N)==0) % end of col
        below = n;
        bl = n-1;
        br = n+1;
    end
    if (mod(n,M)==1) % start of row
        left = n;
        bl = n+M;
        tl = n-M;
    end
    if (n<=M) % start of col
        above = n;
        tl = n-1;
        tr = n+1;
    end
        
    
    
    dirs = zeros(1,8);
    
    dirs(1)  = gradientDir(left);
    dirs(2)  = gradientDir(right);
    dirs(3)  = gradientDir(tl);
    dirs(4)  = gradientDir(above);
    dirs(5)  = gradientDir(tr);
    dirs(6)  = gradientDir(bl);
    dirs(7)  = gradientDir(below);
    dirs(8)  = gradientDir(br);
    
    similar = find(dirs==dir);
    
    
    
end




