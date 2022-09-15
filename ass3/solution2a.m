clc
clear all
load Inorfull
%combining the individual pure spectrum absorbance data
PureAb = [PureCo; PureCr; PureNi]';
[maxAb, idxMaxAb] = max(PureAb);%finding maximum and index of maximum absorbance
lambdaMax = 298+2*idxMaxAb;%calculating maximum absorbance wavelengths

SelData = DATA(:,idxMaxAb);%slicing the data for 
SelC = CONC;
trIdx = 1:1:size(SelC,1);
tsIdx = 1:5:size(SelC,1);
trIdx = setdiff(trIdx,tsIdx);
trSel = SelData(trIdx,:);
trC = SelC(trIdx,:);
meanSel = mean(trSel);
tsSel = SelData(tsIdx,:);
tsC = SelC(tsIdx,:);

A = inv(trSel'*trSel)*trSel'*trC;
Pred = tsSel*A;
RMSE = sqrt(sum((Pred - tsC).^2)/size(Pred,1));








