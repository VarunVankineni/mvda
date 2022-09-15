%Q3
clear all
clc
inorfull=load('Inorfull.mat');
data=inorfull.DATA;
[m,n]=size(data);
newdata=zeros(m/5,n);
%Extracting samples
for i=0:25
    newdata(i+1,:)=data(5*i+1,:);
end

for i=1:m/5
    for j=1:n
        if newdata(i,j)<0
            newdata(i,j)=0;
        end
    end
end

%mean=mean(newdata);
%sd=std(newdata);

%for i=1:176
 %   newdata(:,i)=(-mean(i)+newdata(:,i))/sd(i); 
%end

Z=(newdata)*(newdata.');
[u,s,v]=svd(Z);

lambda = diag(s).^2;
% Variance explained by firts two PCS
explained_variance=sum(lambda(1:3))/sum(lambda);
%Choosing  first three PCs as asked for scores matrix 
scores = (v(:,1:3).')*(newdata);

%Corresponding loadings
loadings=zeros(26,3);
for i=1:3
    loadings(:,i)=v(:,i)*s(i,i);
end

%Some gen playing around
[m,n]=eig(Z);
e=eig(Z);
diav = diag(n); 
%[junk, rindices] = sort(-1*diav); 
%V = diav(rindices);
%PC = PC(:,rindices);
[W,H] = nmf(newdata,loadings,scores,1.0000e-3,1000000,1000);

%Comparing the H matrix with pure spectra for correlations
PureNi=inorfull.PureNi;
PureCo=inorfull.PureCo;
PureCr=inorfull.PureCr;
set1=H(1,:);
set2=H(2,:);
set3=H(3,:);
%A=[PureNi;PureCo;PureCr];

A=cov(set1, PureNi);
B=cov(set1, PureCo);
C=cov(set1, PureCr);
D=cov(set2, PureNi);
E=cov(set2, PureCo);
F=cov(set2, PureCr);
G=cov(set3, PureNi);
J=cov(set3, PureCo);
K=cov(set3, PureCr);
%corr=zeros(3,3);

corr11=A(1,2)/(sqrt(A(1,1))*sqrt(A(2,2)));
corr12=B(1,2)/(sqrt(B(1,1))*sqrt(B(2,2)));
corr13=C(1,2)/(sqrt(C(1,1))*sqrt(C(2,2)));
corr21=D(1,2)/(sqrt(D(1,1))*sqrt(D(2,2)));
corr22=E(1,2)/(sqrt(E(1,1))*sqrt(E(2,2)));
corr23=F(1,2)/(sqrt(F(1,1))*sqrt(F(2,2)));
corr31=G(1,2)/(sqrt(G(1,1))*sqrt(G(2,2)));
corr32=J(1,2)/(sqrt(J(1,1))*sqrt(J(2,2)));
corr33=K(1,2)/(sqrt(K(1,1))*sqrt(K(2,2)));
%Final correlations in the form of a matrix
corr=[corr11,corr12,corr13;corr21,corr22,corr23;corr31,corr32,corr33];


