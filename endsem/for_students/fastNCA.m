function [A P] = fastNCA(Z, As) 

shape = size(As);%get shape of the connectivity matrix structure
species = shape(2);%determine species from shape
[u s v]=svd(Z,'econ'); %economy SVD of the mixture absorbance/microarray data matrix Z 
A = As;%create A to fill in later
Ws = u(:,1:species); %denoised Ws
[val id] = sort(As,'descend'); %sorting to determine which elements in each column have zeros and which do not
nonz = sum(As); %number of nonzero elements in each column of the Astruct

%as per fast NCA algorithm given in the question
for i = 1:shape(2); 
    Wc = Ws(id(1:nonz(i),i),:);
    Wr = Ws(id(nonz(i)+1:end,i),:);
    Ar = As(id(nonz(i)+1:end,i),2:end);
    [ur sr vr] = svd(Wr);
    S = vr(:,end);
    WcS = Wc*S;
    [uf sf vf] = svd(WcS);
    a1 = uf(:,1);
    A(id(1:nonz(i),i),i) = a1;
end
P = inv(A.'*A)*(A.'*Z);


