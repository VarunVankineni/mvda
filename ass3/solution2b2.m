clc
clear all
load Inorfull

Data = DATA;
C = CONC;

trDx = zeros(26,size(DATA,2));
trCx = zeros(26,size(CONC,2));
for i=1:26
    trDx(i,:) = mean(DATA(5*i-4:5*i,:));
    trCx(i,:) = mean(CONC(5*i-4:5*i,:));
end

trD = trDx;
trC = trCx;
tsIdx = 1:5:size(C,1);
tsCx = C(tsIdx,:);
tsDx = Data(tsIdx,:);
tsC = tsCx;
tsD = tsDx;

meanD = mean(trD);
stdD = std(trD);
meanC = mean(trC);
stdC = std(C);

for i=1:size(trD,2)
    trD(:,i) = (trD(:,i)-meanD(i))/stdD(i);
    tsD(:,i) = (tsD(:,i)-meanD(i))/stdD(i);
    trDx(:,i) = (trDx(:,i)-meanD(i))/stdD(i);
    tsDx(:,i) = (tsDx(:,i)-meanD(i))/stdD(i);
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
    trD = trDx*v(:,1:i);
    tsD = tsDx*v(:,1:i);
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