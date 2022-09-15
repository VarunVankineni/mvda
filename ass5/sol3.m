clc
clear all
load yeastdata

X = microarraydata.';
card = sum(Astruct).';
num_comp = size(card,1);

F = sparsePCA(X, card, num_comp,10);

Fcomp = F;
Fcomp(Fcomp~=0)=1;
Fcomp = Fcomp&Astruct;
Fs = sum(Fcomp);
ac = 100 - (100*(card-Fs.')./card);














