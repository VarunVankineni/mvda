clc
clear all
load yeastdata

A = microarraydata;
C_true = Astruct;

size = size(C_true);
[u, s, v] = svd(A,'econ');
spec = size(2);
C_hat = u(:,1:spec);
M = zeros(spec);

for i=1:spec
    zeros = find(C_true(:,i)==0);
    temp = C_hat(zeros,:);
    temp1 = temp(:,[1:i-1 i+1:end]);
    temp2 = -temp(:,i);
    X = inv(temp1.'*temp1)*(temp1.'*temp2);
    X = X.';
    X = [X(1:i-1) 1 X(i:end)];
    M(:,i) = X.';
end

C_star = C_hat*M;
C_star(C_true==0)=0;
% C_star = normc(C_star);
%S_star = inv(C_star.'*C_star)*(C_star.'*normc(A));
% Cstar(Cstar==0)=NaN;
% expr = nanvar(Cstar);
var_c = var(C_star);
[val id] = sort(var_c,'descend');
max_var = tfa(id);

