clc
clear all
load foundry
Data = (Zmeas*diag(1./stdz))/sqrt(413);

[u s v] = svd(cov(Data));
rel = v(:,end);
A = -rel(1:end-1)/rel(end);







