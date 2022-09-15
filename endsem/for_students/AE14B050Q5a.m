clc
clear all
load arx
Y = zn(:,1);
U = zn(:,2);
stdy = sqrt(0.3981);
stdu = sqrt(0.1023);
Y = Y/stdy;
U = U/stdu;

YU = create_stack(Y,U,2);%stacking with order m = 2, will get 4093x5 matrix
YU = YU(:,1:end-1); %remove input stream k-2 from stacked vector
[u s v] = svd(cov(YU));
rel = v(:,end);
A = -rel(1:end-1)/rel(end);



