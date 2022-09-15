clc
clear all
load foundry
Data = Zmeas;
X = Zmeas(:,1:end-1);
%correlation of data for 1st part
% core = corr(Data(:,1:end-1));
% core(core==1)=0;
% maxc = max(abs(core(:)));
% [row,col]=find(core==maxc);
meanX = mean(X);
stdX = std(X);
for i=1:12
    X(:,i)=(X(:,i)-meanX(i))/stdX(i);
end
Y = Zmeas(:,end);
I = eye(12);
lam = 5;%set lambda as required, the penalty parameter
A = inv(X'*X+(lam*I))*(X'*Y);





