clc
clear all
load yeastdata

Cs = Astruct;
MAD = microarraydata;
[Cstar Sstar] = OLSNCA(MAD,Cs);
Cstar = normc(Cstar);%normalize connectivity matrix
Cstar(Cs==0)=0;% set zero exressions from known structure
expr = var(Cstar); %variance of Cstar
[val id] = sort(expr,'descend'); %sort to variance
maxe = tfa(id); %ids of the TFs corresponding to maximum variance




