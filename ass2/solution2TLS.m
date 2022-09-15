
data = csvread('E:\8thsem\MVDA\ass2\assignment2datasets\temperature_global.csv',7,0);
data=data(84:end-1,3:end);%1984-2014
data_shape = size(data);


x_train = data(:,1:end);
x_mean = mean(x_train);
x_std = std(x_train);

shape = size(x_train);

%standard scaling
for i=1:shape(2)
    x_train(:,i) = (x_train(:,i) - x_mean(i))/x_std(i); 
end
y_train = x_train(:,end);

%coefficients in TLS solution
covmat = cov(x_train);
[eigvec,eigval] = eig(covmat);
coef = eigvec(:,1);
coef = -coef(1:end-1)/coef(end);

%error on total data
y_p = x_train(:,1:end-1)*coef;
rms = sqrt(sum((y_train-y_p).^2)/data_shape(1));





