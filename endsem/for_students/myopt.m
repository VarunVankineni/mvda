function [xopt] = myopt(x0,A,Z)

% INPUTS : 
% Zn : stacked input and output data in the same configration as used for
%       estimation of A
% A : constraint matrix 
% x0 : intial value for output and input variance. 

% OUTPUT : returns the x_best = argmin obj(function(x))... obj defined
%           below

% write the function my_obj_fn 
obj = @(x) myobj(x,A,Z);

% imposing postivity constraints using bounds
aub = 1e6;
blb = 1e-4;
lb = blb*ones(1,length(x0));
ub = aub*ones(1,length(x0));

% minimize the cost function using fmincon routine 
[xopt,~] = fmincon(obj,x0,[],[],[],[],lb,ub);
end