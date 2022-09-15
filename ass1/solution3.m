D =[8	6.58
8	5.76
8	7.71
8	8.84
8	8.47
8	7.04
8	5.25
19	12.5
8	5.56
8	7.91
8	6.89];

x=D(:,1);
y=D(:,2);

x_mean=mean(x);
y_mean=mean(y);

Sxy=0;
Sxx=0;

for i=1:11
 Sxy = Sxy + (x(i)-x_mean)*(y(i)-y_mean);
 Sxx = Sxx + (x(i)-x_mean)*(x(i)-x_mean);
end

m=Sxy/Sxx;


c=y_mean - m*x_mean;
fprintf('\n Slope %f',m);
fprintf('\n intercept %f',c);
y1 = m*x + c;
plot(x,y,'*',x,y1,'-');
