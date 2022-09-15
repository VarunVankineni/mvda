clc
clear all
load arx

U = umeas.';
Y = ymeas.';
YU = [Y , U];
YU = YU(1:end-1,:);%1st order
%% OLS
A = pinv(YU)*Y(2:end);
pred = YU*A;
RMSE = sqrt(sum((pred - Y(2:end)).^2)/size(YU,1));
%% TLS
YYU = create_stack(Y,U,1);%[Y(2:end),YU];
[u s v] = svd(cov(YYU));
rel = v(:,end);
At = -rel(2:end)/rel(1);
predt = YU*At;
RMSEt = sqrt(sum((predt - Y(2:end)).^2)/size(YU,1));





