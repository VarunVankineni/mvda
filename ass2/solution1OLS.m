%columns
%"fixed acidity","volatile acidity","citric acid","residual sugar","chlorides",
%"free sulfur dioxide","total sulfur dioxide","density","pH","sulphates",
%"alcohol",
%"quality"

data = csvread('E:\8thsem\MVDA\ass2\assignment2datasets\winequality-white.csv',1,0);
data_shape = size(data);
train_size = 3430;

x_train = data(1:train_size,1:end-1);
y_train = data(1:train_size,end);

x_mean = mean(x_train);
x_std = std(x_train);

x_test = data(train_size+1:end,1:end-1);
y_test = data(train_size+1:end,end);

y_mean = mean(y_train);
y_std = std(y_train);

shape = size(x_train);

%standard scaling
for i=1:shape(2)
    x_train(:,i) = (x_train(:,i) - x_mean(i))/x_std(i); 
end
for i=1:shape(2)
    x_test(:,i) = (x_test(:,i) - x_mean(i))/x_std(i); 
end
y_train = (y_train - y_mean)/y_std; 
y_test = (y_test - y_mean)/y_std; 

%coefficients in OLS solution
coef = inv((x_train.')*x_train)*(x_train.')*y_train;

%error on total data
y_p = [x_train; x_test]*coef;
rms = sqrt(sum(([y_train; y_test]-y_p).^2)/data_shape(1));
%error on testing data
y_ptest = x_test*coef;
rms_test = sqrt(sum((y_test-y_ptest).^2)/(data_shape(1)-train_size));





