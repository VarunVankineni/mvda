clc
clear all
load arx

U = umeas.';
Y = ymeas.';
%% Stacking order 10 
YU10 = create_stack(Y,U,10);
[u s v] = svd(cov(YU10));
meanA = mean(v(:,end-8:end)');
rel10 = v(:,end);
A10 = -rel10(2:end)/rel10(1);
pred10 = YU10(:,2:end)*A10;
RMSE10 = sqrt(sum((pred10 - Y(11:end)).^2)/size(YU10,1));

%% Stacking order 1 >> estimated from s in previous step (significant s = 11 => constraints = 10 => p = 10+1-(m=10)=1)
% YU5 = create_stack(Y,U,1);
% [u s v] = svd(cov(YU5));
% rel5 = v(:,end);
% A5 = -rel5(2:end)/rel5(1);
% pred5 = YU5(:,2:end)*A5;
% RMSE5 = sqrt(sum((pred5 - Y(2:end)).^2)/size(YU5,1));

