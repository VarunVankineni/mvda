clc
clear all
load flowdata
Data = flowdata;
Z = Data'*Data;
[u s v] = svd(Z);
A = v(:,4:end);
Astruct = [1 1 1 0 1 0; 0 1 0 1 1 0; 0 0 1 1 0 1]';
[Ar P M] = OLSNCA(Data', Astruct);
[Ar2 P2 ] = fastNCA(Data', Astruct);


