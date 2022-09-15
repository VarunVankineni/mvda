clear all
%clc
load flowdata1 
Z = Fmeas';
[nvar nsamples] = size(Z);
SZ = Z*Z'/nsamples;  % mean not removed
% scale_factor = sqrt(diag(SZ));
% scale_factor = sqrt(nsamples*diag(Qe));
% scale_factor = [10 5 20 15 1];
scale_factor = sqrt(nsamples)*ones(1,nvar);
% scale_factor = sqrt(nsamples)*std;
flag = 1;
nfact = 2;
sumsing = 0;
iter = 0;
while (flag)
    iter = iter + 1;
    Zs = zeros(nvar,nsamples);
    % Scale the data
    for i = 1:nvar
        for j = 1:nsamples
            Zs(i,j) = Z(i,j)/scale_factor(i);
        end
    end
    % Estimate number of PCs to retain
    [u s v] = svd(Zs,0);
    sdiag = diag(s);
    sumsingnew = sum(sdiag(nfact+1:end));
    %  Obtain constraint matrix in scaled domain
    for k = nfact+1:nvar
        Amat(k-nfact,:) = u(:,k)';
    end
    % Get the constraint matrix in terms of original variables
    for k = 1:nvar
        Amat(:,k) = Amat(:,k)/scale_factor(k);
    end
    if ( abs(sumsingnew -sumsing) <= 0.0001 )
        flag = 0;
    else
        % Estimate covariance matrix (diagonal) and iterate
        eststd = stdest(Amat,Z);
        scale_factor = sqrt(nsamples)*eststd;
        sumsing = sumsingnew;
    end
end

Amat;
spca = diag(s);
% theta_pca = 180*subspace(Atrue', Amat')/pi;
% Determine how well the model matches with the true constraint matrix.
% For this determine the minimum distance of each true constraint vector from the
% row space of model constraints
% for i = 1:3
%     bcol = Atrue(i,:)';
%     dist_pca(i) = norm(bcol - Amat'*inv(Amat*Amat')*Amat*bcol);
% end

% Regression model
% Atrue = [1 -1 0 0 0 0 1 0; 0 1 -1 0 0 0 0 0; 0 0 1 -1 0 0 0 0; 0 0 0 1 -1 -1 0 0; 0 0 0 0 0 1 -1 -1];
% Aind = [Atrue(:,1) Atrue(:,5) Atrue(:,7)];
% Adep = [Atrue(:,2:4) Atrue(:,6) Atrue(:,8)];
% Rtrue = -inv(Adep)*Aind;
% Aindest = [Amat(:,1) Amat(:,5) Amat(:,7)];
% Adepest = [Amat(:,2:4) Amat(:,6) Amat(:,8)];
% Rest = -inv(Adepest)*Aindest;
% maxerr = max(max(abs(Rtrue-Rest)));

