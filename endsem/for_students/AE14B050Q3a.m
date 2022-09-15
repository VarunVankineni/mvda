clc
clear all
load foundry
X = Zmeas(:,1:end-1);
meanX = mean(X);
stdX = std(X);
for i=1:12
    X(:,i)=(X(:,i)-meanX(i))/stdX(i);
end
Y = Zmeas(:,end);
A = pinv(X)*Y;


