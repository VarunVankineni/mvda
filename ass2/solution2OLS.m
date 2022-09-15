
data = csvread('E:\8thsem\MVDA\ass2\assignment2datasets\temperature_global.csv',7,0);
data=data(84:end-1,3:end);%1984-2014
data_shape = size(data);


x_train = data(:,1:end-1);
x_mean = mean(x_train);
x_std = std(x_train);


y_train = data(:,end);
y_mean = mean(y_train);
y_std = std(y_train);

shape = size(x_train);

%standard scaling
for i=1:shape(2)
    x_train(:,i) = (x_train(:,i) - x_mean(i))/x_std(i); 
end
y_train = (y_train - y_mean)/y_std; 

%coefficients in OLS solution
coef = inv((x_train.')*x_train)*(x_train.')*y_train;

%error on total data
y_p = x_train*coef;
rms = sqrt(sum((y_train-y_p).^2)/data_shape(1));





