clc
clear all
load ncadata
Ctrue = [1,1,0;1,0,1;0,1,1;1,0,1;1,1,0;1,0,1;0,1,1];
S = pureabs;
A = measabs;
%[Cstar Sstar M]= OLSNCA(A, Ctrue);  %OLS NCA
[Cstar Sstar]= fastNCA(A, Ctrue);  %fast NCA use as required
cor = corr(S.',Sstar.'); %correlation between true and estimated pure absorbance spectrums