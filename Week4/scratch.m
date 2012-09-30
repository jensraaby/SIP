barbara=imread('barbara.tif');
    

% do the inversion:
%inverted = rangetransform(barbara,150,0);
%imshow(inverted);


% Question 4.3co
X = 0.00:0.01:1;

Y = 1/2 * (1 + cos(2* pi() * X));

Yc = cumsum(Y);

h_43 = figure;
plot(X,Y);
hold on


plot(X,Yc/max(Yc),'g');

ylabel('s=g(r)');
xlabel('r');
legend('PDF','CPD');

s = 0.2
r1 = acos((2*s-1))/(2*pi)
r2 = 1 - acos((2*s-1))/(2*pi)

% plot(r1,s,'ro');
% plot(r2,s,'ro');
hold off

% print(h_43,'-dpdf','report/q3-plot.pdf')

% now second part


% s=0.0:0.1:1;
% for k=1:length(s)
%     r(k) = 2/(2*pi()*sqrt(-(s(k)-1)*s(k)));
% endb
% figure,plot(s,r);
%%
s = 0:0.001:1;
for k=1:length(s)
    r1 = acos((2*s(k)-1))/(2*pi)
    r2 = 1 - acos((2*s(k)-1))/(2*pi)
    r_1(k) = r1;
    r_2(k) = r2;
    cpd_s(k) = r2-r1;
end
h_ps = figure;
plot(s,cpd_s);
hold on
plot(s,r_1,'g');
plot(s,r_2,'r');
xlabel('s');
ylabel('P_S(s)');


% print(h_ps,'-dpdf','report/q3-cpds.pdf');

%%
im = im2double(imread('q43-gradient.tif'));
 compare=figure;
 subplot(2,2,1);
% bh = figure;
imhist(im);
 subplot(2,2,2);
imshow(im,'border','tight');
 subplot(2,2,3);
[s_b,psb] = transformQ3(im);
% ah = figure;
imhist(s_b);
 subplot(2,2,4);
 imshow(s_b,'border','tight');
% print(compare,'-dpdf','report/q3-compare.pdf')
% imwrite(s_b,'report/q3-afterim.png');
% imwrite(im,'report/q3-beforeim.png');
% print(ah,'-dpdf','report/q3-afterhist.pdf');
% print(bh,'-dpdf','report/q3-beforehist.pdf')