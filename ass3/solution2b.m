clc
clear all
load Inorfull



Data = DATA;
C = CONC;

trIdx = 1:1:size(C,1);
tsIdx = 1:5:size(C,1);
trIdx = setdiff(trIdx,tsIdx);
trD = Data(trIdx,:);
trC = C(trIdx,:);
tsD = Data(tsIdx,:);
tsC = C(tsIdx,:);

meanD = mean(trD);
stdD = std(trD);
meanC = mean(trC);
stdC = std(C);
for i=1:size(trD,2)
    trD(:,i) = (trD(:,i)-meanD(i))/stdD(i);
    tsD(:,i) = (tsD(:,i)-meanD(i))/stdD(i);
    Data(:,i) = (Data(:,i)-meanD(i))/stdD(i);
end
for i=1:size(trC,2)
    trC(:,i) = (trC(:,i)-meanC(i))/stdC(i);
    tsC(:,i) = (tsC(:,i)-meanC(i))/stdC(i);
end

[u s v] = svd(trD);
lambda = diag(s).^2;

pcVar = 0.99;
sumLambda = sum(lambda);
newSum = 0;
pcs = 0;
for i=1:size(lambda,1)
    newSum = newSum + lambda(i);
    if((newSum/sumLambda)>=pcVar)
        pcs = i;
        break
    end
end

RMSE = zeros(size(lambda,1),3);
lenPred = 26;
for i=1:size(lambda,1)
    NewData = Data*v(:,1:i);
    trD = NewData(trIdx,:);
    tsD = NewData(tsIdx,:);
    A = inv(trD'*trD)*(trD'*trC);
    Pred = tsD*A;
    RMSE(i,:) = sqrt(sum((Pred - tsC).^2)/lenPred);
end
newRMSE = sqrt(sum(RMSE.^2,2)/3);
[min, idxMin] = min(newRMSE);
plot(newRMSE);
grid on
ax = gca;
ax.XLabel.String = 'PCs Chosen';
ax.YLabel.String = 'RMSE error in autoscaled domain';
ax.FontWeight = 'bold';
