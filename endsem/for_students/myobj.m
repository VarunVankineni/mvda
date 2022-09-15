function [mle,r] = myobj(x,A,Z)
    N = size(Z,1);
    L = size(Z,2)/2;
    E = [];
    for i=1:L+1
        E = [E,x(1)];
    end
    for i=1:L
        E = [E,x(2)];
    end
    E = diag(E);
    AEA =  A*E*A';
    r = (A*Z')';
    mle1 = N*log(det(AEA));
    mle2 = 0;
    for i = 1:N
        mle2 = mle2+(r(i,:)*inv(AEA))*r(i,:)'; 
    end
    mle = mle1+mle2;
end