% first SIP exercises

z1 = complex(2,3);
z2 = complex(3,-2);
zprod = z1*z2

zsum = z1+z2

z3 = z1/z2
% = (z1 * z1-conjug)/(z2 * z2conjug)
% = 1/13 (2+3i)(3+2i) = 1/13i

% converting to polar
% z1 = a +ib, z2 = c+id
% r = |z|, v = arctan(b/a)
% z1 = |z1| e^(i v1), v1 = arctan(b/a)
% z2 = |z2| e^(i v2), v2 = arctan(d/c)
% product z1z2 = |z1| e^(i v1) |z2| e^(i v2)
% rearrange
% |z1||z2| e^(i v2)e^(i v1) = |z1||z2| e^i(v1 v2)
% |z1| = root(z1 z1conjug)
% |z1||z2| root(z1 z1conj z2 z2conj|
% root(z1 z2 z1conj z2conj)  = |z1z2|

% if z = (1,v) = 1 * e^(iv) = e^(iv)
% (e^(iv))^n = e^(niv) = (1,mv)