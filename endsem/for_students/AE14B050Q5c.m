clc
clear all
load arx
Y = zn(:,1);
U = zn(:,2);
stdy = sqrt(0.3981);
stdu = sqrt(0.1023);
Y = Y/stdy;
U = U/stdu;
YU = create_stack(Y,U,10);
[u s1 v1] = svd(cov(YU));
A1 = v1(:,end-8:end)';
A1 = mean(A1);
eigv1 = diag(s1)
%last 9 eigenvalues are insignificant using m = 10 >> do again for m=5 
YU = create_stack(Y,U,5);
[u s v] = svd(cov(YU));
eigv = diag(s);
% last 4 eigenvalues are insignificant using m = 5 >> do again for m=3
YU = create_stack(Y,U,3);
[u s v] = svd(cov(YU));
eigv = diag(s);
% last 2 eigenvalues are insignificant using m = 3 >> do again for m=2
YU = create_stack(Y,U,2);
[u s v] = svd(cov(YU));
eigv = diag(s);
%only 1 eigenvalue is insignificant, hence we obtain the model 
rel = v(:,end);
A = -rel(1:end-1)/rel(end);
