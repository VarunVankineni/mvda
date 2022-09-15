clc
clear all
load Inorfull



Data = DATA;
C = CONC;
lambdas = 298+2*(1:176);
stdWave = zeros(26,size(DATA,2));
for i=1:26
    stdWave(i,:) = std(DATA(5*i-4:5*i,:));
end
stdWave = mean(stdWave);

%plot(lambdas,stdWave');
% % stdWave = std(mean(stdWave));
% stdMix = std(DATA,0,2);
% plot(stdMix)
% 
% grid on
% ax = gca;
% ax.XLabel.String = 'Error standard deviations';
% ax.YLabel.String = 'Wavelengths';
% ax.FontWeight = 'bold';

Linv = diag(1./stdWave)/sqrt(104);
Data = Data*Linv;

trIdx = 1:1:size(C,1);
tsIdx = 1:5:size(C,1);
trIdx = setdiff(trIdx,tsIdx);
trD = Data(trIdx,:);
trC = C(trIdx,:);
tsD = Data(tsIdx,:);
tsC = C(tsIdx,:);


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

