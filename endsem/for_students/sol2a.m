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

%% Stacking order 10 
YU10 = create_stack(Y,U,10);
[u s v] = svd(cov(YU10));
rel10 = v(:,end);
A10 = -rel10(2:end)/rel10(1);
pred10 = YU10(:,2:end)*A10;
RMSE10 = sqrt(sum((pred10 - Y(11:end)).^2)/size(YU10,1));

%% Stacking order 5 >> estimated from s in previous step
YU5 = create_stack(Y,U,5);
[u s v] = svd(cov(YU5));
rel5 = v(:,end);
A5 = -rel5(2:end)/rel5(1);
pred5 = YU5(:,2:end)*A5;
RMSE5 = sqrt(sum((pred5 - Y(6:end)).^2)/size(YU5,1));
%% Model order == 5, 




