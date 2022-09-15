% Test PCA
clc
clear all

nvar = 5;
nsamples = 1000;
% True constraint matrix
Atrue = [1 1 -1 0 0; 0 0 1 -1 0; 0 -1 0 1 -1];
% True values of variables
Fbase(1,1) = 10;
Fbase(1,2) = 10;
Fbase(1,3) = Fbase(1,1)+Fbase(1,2);
Fbase(1,4) = Fbase(1,3);
Fbase(1,5) = Fbase(1,4) - Fbase(1,2);

% Parameters for random walk model
lamda(1) = 1.0;
lamda(2) = 2.0;
lamda(3) = 0.8;
lamda(4) = 1.2;


% Standard deviation of measurement errors (No errors)
% std(1) = 0.0;
% std(2) = 0.0;
% std(3) = 0.0;
% std(4) = 0.0;
% std(5) = 0.0;

% Standard deviation of measurement errors (equal variances)
% std(1) = 0.1;
% std(2) = 0.1;
% std(3) = 0.1;
% std(4) = 0.1;
% std(5) = 0.1;
% 
% % Standard deviation of measurement errors (unequal variances - high SNR)
std(1) = 0.1;
std(2) = 0.08;
std(3) = 0.15;
std(4) = 0.2;
std(5) = 0.18;
% 
% Standard deviation of measurement errors (unequal variances - low SNR)
% std(1) = 1;
% std(2) = 0.8;
% std(3) = 1.5;
% std(4) = 2.0;
% std(5) = 1.8;
% 
Ltrue = diag(std);

% Tolerance for convergence
tol = 1e-06;
% Reset random number generator to initial state
randn('state',5);

for j = 1:nsamples
    for k = 1:2
        Ftrue(j,k) = Fbase(k) + lamda(k)*randn; 
    end
    Ftrue(j,3) = Ftrue(j,1) + Ftrue(j,2);
    Ftrue(j,4) = Ftrue(j,3);
    Ftrue(j,5) = Ftrue(j,4) - Ftrue(j,2);
end

for j = 1:nsamples
    error = randn(nvar,1);
    Fmeas(j,:) = Ftrue(j,:) + (Ltrue*error)';
end

SY = zeros(nvar);
for j = 1:nsamples
    SY = SY + Fmeas(j,:)'*Fmeas(j,:);
end
meanY = mean(Fmeas);
covY = (SY - nsamples*meanY'*meanY)/(nsamples-1);

% Different scaling strategies
% Lsinv = eye(nvar);  % No scaling
% Lsinv = diag(ones(nvar,1)./sqrt(diag(covY)));  % Scaling by measurement variances
Lsinv = inv(Ltrue);  % Scaling by cholesky factor of true error covariance matrix

nfact = 2;
%  Apply PCA to denoise the data
Ys = Fmeas*Lsinv/sqrt(nsamples);

[u s v] = svd(Ys);

% Obtain the denoised estinates
Fhat = u(:,1:nfact)*u(:,1:nfact)'*Fmeas;

%  Compute the total error in the measured data and the denoised data for
%  all variables
for j = 1:nvar
    j
    E1 = (Fmeas(:,j)-Ftrue(:,j))'*(Fmeas(:,j)-Ftrue(:,j))/nsamples
    E2 = (Fhat(:,j)-Ftrue(:,j))'*(Fhat(:,j)-Ftrue(:,j))/nsamples
end
