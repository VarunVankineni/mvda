%columns
%"fixed acidity","volatile acidity","citric acid","residual sugar","chlorides",
%"free sulfur dioxide","total sulfur dioxide","density","pH","sulphates",
%"alcohol",
%"quality"

data = csvread('E:\8thsem\MVDA\ass2\assignment2datasets\winequality-red.csv',1,0);
data_shape = size(data);
train_size = 1120;

x_train = data(1:train_size,:);

x_mean = mean(x_train);
x_std = std(x_train);

x_test = data(train_size+1:end,1:end-1);
y_test = data(train_size+1:end,end);

shape = size(x_train);

%standard scaling
for i=1:shape(2)
    x_train(:,i) = (x_train(:,i) - x_mean(i))/x_std(i); 
end
for i=1:shape(2)-1
    x_test(:,i) = (x_test(:,i) - x_mean(i))/x_std(i); 
end
y_test = (y_test - x_mean(end))/x_std(end); 


%coefficients in TLS solution
covmat = cov(x_train);
[eigvec,eigval] = eigs(covmat,1,'SM');
coef = eigvec;
coef = -coef(1:end-1)/coef(end);

%error on total data
y_p = [x_train(:,1:end-1); x_test]*coef;
rms = sqrt(sum(([x_train(:,end); y_test]-y_p).^2)/data_shape(1));

%error on testing data
y_ptest = x_test*coef;
rms_test = sqrt(sum((y_test-y_ptest).^2)/(data_shape(1)-train_size));




