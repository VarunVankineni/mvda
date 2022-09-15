clc
clear all
load vpdata

%% Scaling Data with training set
train = 70;
test = size(temp,1)-train;
P = psat(1:train);
T = temp(1:train);
meanP = mean(P);
meanT = mean(T);
stdP = std(P);
stdT = std(T);
P = (P-meanP)/stdP;
T = (T-meanT)/stdT;

%% Kernel params - training data kernel
minD = zeros(train,1);
distM = zeros(train);
for i=1:train
    dist = bsxfun(@minus,T,T(i,:));
    dist = sum(dist.^2,2);
    distM(:,i)=dist;
    dist = sqrt(dist);
    dist(i)=[];
    minD(i)=min(dist);
end
sig = 5*mean(minD);%kernel width or sigma as a function of 
%the mean minimum nearest point distance of each point
sig2 = 2*sig*sig; % sigma^2

%% Estimate number of principle components and width using PRESS
%Gaussian Kernel matrix
K = exp(-distM/sig2);
I = ones(size(K))/train;
[u s v] = svd(K,'econ');
PRESS = zeros(train,1);
for i=1:train
    proj = K*v(:,1:i);
    A = pinv(proj)*P; %OLS trained A
    
    testT = temp(train+1:end);%test data
    testT = (testT-meanT)/stdT;%scaling test data
    %% Compute Kernel, principle component projections for test data for cross validation
    testk = zeros(test,train);
    for j=1:test
        testk(j,:) = (T - testT(j));
    end
    testk = exp(-(testk.^2)/sig2);
    proj = testk*v(:,1:i);
    
    %% Predict pressure using the trained A and the principle components
    pred = (proj*A);
    %% PRESS error
    testP = psat(train+1:end);
    testP = (testP-meanT)/stdT;
    PRESS(i) = sum((pred-testP).^2);
end

%% Find Id of least PRESS value
PRESS(PRESS>1e2)=100;%correct for very large values, makes finding minimum faster
[val id] = min(PRESS);
p= id; %we get the optimum number of principle components 
%% Predict pressures for p principle components - same as in the forloop above, better to compute this again than store all those above predicted pressure values
proj = K*v(:,1:p);
A = pinv(proj)*P; %OLS trained A

testT = temp(train+1:end);%test data
testT = (testT-meanT)/stdT;%scaling test data
%% Compute Kernel, principle component projections for test data for cross validation
testk = zeros(test,train);
for j=1:test
    testk(j,:) = (T - testT(j));
end
testk = exp(-(testk.^2)/sig2);
proj = testk*v(:,1:p);
    
%% Predict pressure using the trained A and the principle components
pred = (proj*A);

%% PRESS error
testP = psat(train+1:end);
testP = (testP-meanT)/stdT;
PRESS = sum((pred-testP).^2);

%% Predicted pressure scaled back, and RMSE
predict = pred*stdP+meanP;
RMSE = sqrt(mean((predict-psat(train+1:end)).^2));

%% Special cases for (b)
testT = 100;%set value
predictA = exp(14.0568-(2825.42/(testT+230.44)));%antoine equation prediction
testT = (testT-meanT)/stdT;
testk = ((T-testT).^2);
testk = exp(-testk/sig2);
proj = testk.'*v(:,1:p);
predict1 = proj*A;
predict1 = predict1*stdP + meanP;%predicted solution scaled back
error = 100*abs(predictA-predict1)/predictA;








