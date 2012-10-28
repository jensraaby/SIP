t=-1:0.01:3;
y=zeros(1,length(t));
for i=1:length(t)
    
  if(t(i)>=0 && t(i) < 1) 
      y(i) = t(i);
      
  elseif t(i)>=1 && t(i) <2
      y(i) = 2-t(i);
      
  else
      y(i) = 0;
  end
end
y_orig = y;

%%
for m = 1:5
    k = m-1;
    for i=1:length(t)
       if k/2 <= t(i) && t(i) < k/2 + 1/2
           y(m,i) = 2* t(i) - k;
       elseif k/2 + 1/2 <= t(i) && t(i) < k/2 + 1
           y(m,i) = 2 + k - (2* t(i));
       else
           y(m,i) = 0;
       end
    end
end
%% wavelets
for m = 1:5
    k = m-1;
    for i=1:length(t)
       y(m,i) = phi(2*t(i) - k);
       yw(m,i) = psi(2*t(i)-k);
    end
end
% for i=1:length(t)
%     
%   if(t(i)>=0 && t(i) < 1/2) 
%       y2(i) = 2*t(i);
%       y3(i) = 0;
%       y4(i) = 0;
%   elseif t(i)>=0.5 && t(i) <1
%       y2(i) = 2-(2*t(i));
%       y3(i) = 2*t(i)-1;
%       y4(i) = 0;
%   elseif t(i)>=1 && t(i) <1.5
%       y3(i) = (2-(2*t(i)))+1;
%       y2(i) = 0;
%       y4(i) = 2*t(i)-2;
%   elseif t(i) >= 1.5 && t(i) < 2
%       y2(i) = 0;
%       y3(i) = 0;
%       y4(i) = (2-(2*t(i)))+2;
%   else
%       y2(i) = 0;
%       y3(i) = 0;
%       
%   end
% end
%%
unscaled = figure;
plot(t,yw(1,:)); legend('\psi(t)');
print(unscaled,'-dpdf','report/q2-w0.pdf');
% hold on
% plot(t,y(1,:),'--r');
% plot(t,y(2,:),'--g');
% plot(t,y(3,:),'--k');
% legend('\phi (t)','\phi (2t)','\phi (2t-1)','\phi (2t-2)');
% hold off
% print(unscaled,'-dpdf','report/q2-unscaled.pdf');
%%
scaled = figure(2);

plot(t,0.5*y(1,:),'r'); hold on
plot(t,y(2,:),'g');
plot(t,0.5*y(3,:),'k');
legend('0.5 * \phi (2t)','\phi (2t-1)','0.5 * \phi (2t-2)')
hold off
print(scaled,'-dpdf','report/q2-v1.pdf');
