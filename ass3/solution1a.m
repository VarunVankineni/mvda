clc
clear all
load flowdata2

%load into memory basic shape of the matrix for further use
shapeF = size(Fmeas);

%create the cholesky inverse for the measured data
Linv = diag(1./stdtrue);

%scale the corresponding data to obtain equal error standard deviations and
%hence the variances across all the data, so that PCA is applicable
Fs = Fmeas*Linv/sqrt(shapeF(1));

%perform svd of the above scaled matrix and true data matrix
[u s v] = svd(Fs);
[ut st vt] = svd(Ftrue/sqrt(shapeF(1)));

%use the eigen vectors to create the contsraint matrices
Ahat = fliplr(v)'*Linv;%scaling back the constraint coefficients to original space
Atrue = fliplr(vt)';

%input the independent variables we are choosing
indep = [1 1 1 0 0];
eqns = shapeF(2)-sum(indep);%number of dependent variables

%slice the constraint matrices by selecting those eigen vectors corresponding to the
%lowest number of eigenvalues such that number of rows in the new contsraint
%matrices are the as same the number of dependent variables so that an inverse
%can be defined
Ahat = Ahat(1:eqns,:);
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