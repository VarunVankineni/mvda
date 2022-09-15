clc
clear all
load yeastdata

Zs = microarraydata;
As = Astruct;
[Af P]= fastNCA(Zs, As);
%P = normc(P);
Af(Af==0)=NaN;
expr = nanvar(Af);
expr = sum(P.^2,2);
[val id] = sort(expr);
maxe = tfa(id);













