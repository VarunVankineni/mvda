clc
clear all
load Inorfull

shape = size(DATA);
eqns = 173;

convCrit = 0.0001;%convergenge criterion for stopping the iterations
itrCount = 0;%count for number of iterations
sSum = 0;%initialized sum of the eigenvalues correspoding to the number of equations
notConverged = true;%boolean for convergence check
initStd = eye(shape(2));%initialized identity standard deviations
Linv = inv(sqrt(shape(1))*initStd);%cholesky transform inverse
sList = zeros(eqns,1);

for i = 173:173
    itrCount = 0;%count for number of iterations
    sSum = 0;%initialized sum of the eigenvalues correspoding to the number of equations
    notConverged = true;%boolean for convergence check
    initStd = eye(shape(2));%initialized identity standard deviations
    Linv = inv(sqrt(shape(1))*initStd);%cholesky transform inverse
    while (and(notConverged,(itrCount<=1000)))
        itrCount = itrCount +1;
        Ds = (Linv*DATA')';
        [u s v] = svd(Ds,0);

        newSum = diag(s);
        newSum = sum(newSum(((shape(2)-i+1):end)));
        if(abs(newSum-sSum)<=convCrit)
            notConverged = false;
        end
        Ahat = fliplr(v)';
        Ahat = Ahat(1:i,:)*Linv;
        newStd = stdest(Ahat,DATA');
        Linv = inv(diag(sqrt(shape(1))*newStd));
        sSum = newSum;
    end
    sList(i)= sSum;
    stdmean = mean(stdDATA);
end
plot([stdmean',newStd])

grid on
ax = gca;
ax.XLabel.String = 'Error standard deviations';
ax.YLabel.String = 'Wavelengths';
ax.FontWeight = 'bold';

Data = DATA;
C= CONC;
Linv = diag(1./newStd)/sqrt(104);
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
