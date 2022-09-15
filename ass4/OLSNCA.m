function [A P M] = OLSNCA(Z, As) 

shape = size(As); %get shape of the connectivity matrix structure
species = shape(2); %determine species from shape
[u s v]=svd(Z,'econ'); %economy SVD of the mixture absorbance/microarray data matrix Z 
Ahat = u(:,1:species); %denoise by taking only the first n_s columns of u as Ahat
M = zeros(species); %Create M matrix for speed
insert1 = @(x, n)cat(2,  x(1:n-1), 1, x(n:end)); %helper function to insert 1
for i=1:species %iterated over the columns of Astruct
    dum=[];
    for j=1:shape(1) %get rows from Ahat which have zeros in Astruct 
        if(As(j,i)==0)
            dum = [dum;Ahat(j,:)];
        end   
    end
    LHS = dum; 
    LHS(:,i)=[]; %remove the column from dum that corresponds to the 1 diagnol in M. essentially finding A in AX = b.
    RHS = -dum(:,i); % set this column as -b in AX=b system
    X = inv(LHS.'*LHS)*(LHS.'*RHS); %OLS solution
    X = insert1(X.',i); %adding 1 in appropriate place
    M(:,i)= X.'; %setting the ith column of M
end
A = Ahat*M; %rotating with scale ambiguity to get A
P = inv(A.'*A)*(A.'*Z); 