clear all
sigma = sqrt(2);
img = imread('Lena.tif');
img = im2double(img);
[M, N] = size(img);

[mir,Fmir] = mirrorpadding(img);

% Compute Derivatives with Scale :
Dx = scale(Fmir,sigma,0,1);
Dy = scale(Fmir,sigma,1,0);
dx = ifft2(Dx);
dy = ifft2(Dy);
% We only need to think about the unpadded image
dx = dx(1:M,1:N);
dy = dy(1:M,1:N);

% imshow(dx + dy,[]);

% Compute directions for all pixels
direction = atan((dy)./(dx))*180/pi; % in degrees (can be pos or neg

% Compute magnitude
magnitude = sqrt(dx.*dx + dy.*dy); % = hypot(dx,dy); better syntax

% normalise the magnitudes
if max(magnitude(:)) ~= 0
    magnitude = magnitude/max(magnitude(:));
end

% find the indices of all the 4 directions (of a 3x3 neighbourhood)
tic
dir{1} = find(-22.5 < direction & direction <= 22.5); %horizontal
dir{1} = [dir{1}; find(-157.5 > direction & direction >= -202.5)];

dir{2} = find(22.5 < direction & direction <= 67.5); %diag 1
dir{2} = [dir{2}; find(-112.5 > direction & direction >= -157.5)];

dir{3} = find(67.5 < direction & direction <= 112.5); %vertical
dir{3} = [dir{3}; find(-67.5 > direction & direction >= -112.5)];

dir{4} = find(112.5 < direction & direction <= 157.5); %diag 2
dir{4} = [dir{4}; find(-22.5 > direction & direction >= -67.5)];

direction_label(dir{1}) = 1;
direction_label(dir{2}) = 2;
direction_label(dir{3}) = 3;
direction_label(dir{4}) = 4;
toc


%% Nonmaxima suppression
tic
g_N = zeros(M,N);
for n=1:numel(img)
    n_dir = direction_label(n);
    
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
    fstDir = direction_label(first);
    sndDir = direction_label(second);
    
    % make a vector of the en-edge magnitudes
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
        g_N(n) = 0;
    else
        g_N(n) = maxmag;
    end
end
toc

%% Double Threshold


t_high = 0.1;
t_low  = 0.4 * t_high;

% from Gonzalez and Woods p 722:
g_NH = zeros(M,N); % strong
g_NL = zeros(M,N); % weak

g_NH(g_N>=t_high) = 1; % strong
g_NL(g_N>=t_low)  = 1; % weak+strong
g_NL = g_NL-g_NH;  % weak

tic
g_NH2 = zeros(size(g_NH)); % strengthened edges
for x=2:M-1 % exclude borders
    for y=2:N-1
        if (g_NH(x,y) == 1) % edge pixel - if any neighbours are weak edges, make them strong
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
toc
final = g_NH;
figure,imshow(final,[]);
%% connect weak to strong
[C,R] = find(g_NH);
%  C = rem(find(g_NH)-1,M) +1;
%  R = floor((find(g_NH)-1)/M)+1;
% 
% find the 8-connected weak edges
g_NL2 = bwselect(g_NL,C,R,8);

