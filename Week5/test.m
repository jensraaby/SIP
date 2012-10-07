figure

s = [zeros(1,100), ones(1,100)];
plot(s)

axis([0,200, -1,2]);
I = s + .25*randn(1,200);
plot(I);

plot(I(2:200) - I(1:199))
sig = 2.5; a = -100:1:99; G = exp( (- a.^2)/ (2*sig*sig))/(sig*(sqrt(2*pi)));
plot(G)
GI = conv(G,I);
GI = GI(150:250);
plot(GI)
plot(GI(3:100) - GI(1:98))
% Why is subtracting GI shifted from GI the same as filtering GI with 
% [-1 0 1]?

% Filtering is associative.

GD = G(3:200) - G(1:198);
plot(GD)
GDI = conv(GD,I);
GDI = GDI(150:250);
plot(GDI)
figure
plot(GI(3:100) - GI(1:98))

% Finding peaks

PEAKS = [0, (GDI(2:100) > GDI(1:99) & GDI(2:100) > GDI(3:101)), 0];
figure
plot(PEAKS.*GDI)
plot(PEAKS.*GDI > .1)

% Scale
s2 = [zeros(1,60), ones(1,10), zeros(1,60), ones(1,70)];
plot(s2)
axis([0,200, -1,2])
I2 = s2 + .1*randn(1,200);
plot(I2)
sig = 1; a = -100:1:99; G = exp( (- a.^2)/ (2*sig*sig))/(sig*(sqrt(2*pi)));GI2 = conv(G,I2);GI2 = GI2(101:300);
plot(GI2)
plot(GI2(3:200) - GI2(1:198))
sig = 5; a = -100:1:99; G = exp( (- a.^2)/ (2*sig*sig))/(sig*(sqrt(2*pi)));GI2 = conv(G,I2);GI2 = GI2(101:300);
plot(GI2(3:200) - GI2(1:198))
sig = 15; a = -100:1:99; G = exp( (- a.^2)/ (2*sig*sig))/(sig*(sqrt(2*pi)));GI2 = conv(G,I2);GI2 = GI2(101:300);
plot(GI2(3:200) - GI2(1:198))

% Corners

I = 100*ones(200,200);
for i = 100:150 for j = 50:(150-2*(i-100)) I(i,j) = 150; end, end
imagesc(I)
I = I+40*randn(200,200);
imagesc(I)
imshow(edge(I,'canny',[],2))
imshow(edge(I,'canny',[],5))
imshow(edge(I,'canny',[],8))
