clc
clear all
load flowdata2

%load into memory basic shape of the matrix for further use
shapeF = size(Fmeas);
%input the independent variables we are choosing
indep = [1 0 0 0 1];
eqns = shapeF(2)-sum(indep);%number of dependent variables

%Parameters
convCrit = 0.0001;%convergenge criterion for stopping the iterations
itrCount = 0;%count for number of iterations
sSum = 0;%initialized sum of the eigenvalues correspoding to the number of equations
notConverged = true;%boolean for con1vergence check
initStd = eye(shapeF(2));%initialized identity standard deviations
Linv = inv(sqrt(shapeF(1))*initStd);%cholesky transform inverse

%IPCA for 3 dependent variables
while (notConverged)
    itrCount = itrCount +1;
    Fs = (Linv*Fmeas')';
    [u s v] = svd(Fs,0);
    
    newSum = diag(s);
    newSum = sum(newSum(((shapeF(2)-eqns+1):end)));
    if(abs(newSum-sSum)<=convCrit)
        notConverged = false;
    end
    Ahat = fliplr(v)';
    Ahat = Ahat(1:eqns,:)*Linv;
    newStd = stdest(Ahat,Fmeas');
    Linv = inv(diag(sqrt(shapeF(1))*newStd));
    sSum = newSum;
end


%perform svd of the true data matrix
[ut st vt] = svd(Ftrue);

%use the eigen vectors to create the contsraint matrix
Atrue = fliplr(vt)';

%slice the constraint matrix by selecting those eigen vectors corresponding to the
%lowest number of eigenvalues such that number of rows in the new contsraint
%matrices are the same as the number of dependent variables so that an inverse
%can be defined
Atrue = Atrue(1:eqns,:);

%allocate independent and dependent matrices for speed before filling
AI = zeros(eqns,sum(indep));
AIhat = AI;
AD = zeros(eqns,eqns);
ADhat = AD;
itr1=0;
itr2=0;
for i = 1:shapeF(2)
    if indep(i)==0
        itr1=itr1+1;
        AD(:,itr1) =  Atrue(:,i);
        ADhat(:,itr1) =  Ahat(:,i);
    elseif indep(i)==1
        itr2=itr2+1;
        AI(:,itr2) =  Atrue(:,i);
        AIhat(:,itr2) =  Ahat(:,i);
    end
end

%calculate the relational matrices betweent the dependent and independent
%variables
R = -inv(AD)*AI;
Rhat = -inv(ADhat)*AIhat;
%find difference between them to compare how accurately we have measured
%the original constraints
Diff = R-Rhat;
maxDiff = max(max(abs(R-Rhat)));
