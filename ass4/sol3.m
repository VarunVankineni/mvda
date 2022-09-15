clc
clear all
load Inorfull

A = DATA;
C = CONC;
S = [;PureNi/PureNiCONC;PureCr/PureCrCONC;PureCo/PureCoCONC;]; %pure absorbances scaled to unitary concentrations
shape =size(C);
species = shape(2);

fsamples= 1:5:size(A,1);
A1 = A(fsamples,:);%matrix with first samples 
A1(A1<0)=0;%setting negatives to zero

Aavg = A1; %creating the averaged data matrix with A1 structure
for i = fsamples
    Aavg((i+4)/5,:) = mean(A(i:i+4,:));
end
Aavg(Aavg<0)=0;

[u s v] = svd(A1); %pca using first samples
Sinit = v(:,1:species).'; %loadings
Cinit = A1*Sinit.'; %scores
Sinit = abs(Sinit); %absolute values
Cinit = abs(Cinit);

[Cest,Sest] = nmf(A1,Cinit,Sinit,1e-12,100,10000); %nmf
cor1 = corr(Sest.',S.'); %correlation of true and estimated pure absorbance spectrums

[u s v] = svd(Aavg); %pca using averaged data, use and comment as required
Sinit = v(:,1:species).'; %loadings
Cinit = A1*Sinit.'; %scores
Sinit = abs(Sinit); %absolute values
Cinit = abs(Cinit);

[Cest,Sest] = nmf(Aavg,Cinit,Sinit,1e-12,100,10000); %nmf
cor = corr(Sest.',S.'); %correlation of true and estimated pure absorbance spectrums


