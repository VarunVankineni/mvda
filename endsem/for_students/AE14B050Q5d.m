clc
clear all
load arx
Y = zn(:,1);
U = zn(:,2);
YU = create_stack(Y,U,10);
[u s1 v] = svd(cov(YU));
A = v(:,end-8:end)';
x0 = [0.5,0.2];
xf = myopt(x0,A,YU);
stdy = sqrt(xf(1));
stdu = sqrt(xf(2));
Y = Y/stdy;
U = U/stdu;
YU = create_stack(Y,U,10);
[u s1 v1] = svd(cov(YU));
A1 = v1(:,end-8:end)';
A1 = mean(A1);
eigv1 = diag(s1)