clc
clear all
load yeastdata

Cs = Astruct;
MAD = microarraydata;
[Cstar Sstar M] = OLSNCA(MAD,Cs);
Cstar(Cs==0)=0;
expr = var(Cstar);
[val id] = sort(expr,'descend');
maxe = tfa(id);



