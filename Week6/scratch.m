t=-1:0.1:3;
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
phi = @(x)(
if(0<=x & x<1) 
    x; 
elseif (1<=x & x<2) 
    2-x; 
else 0; 
end);
    
  plot(t,y);