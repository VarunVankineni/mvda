clc
clear all
load audiomixture
[ken,Fken] = audioread('kennedy_ask_not.wav');
[no,Fno] = audioread('no_ways_tired.wav');

%% Find the independent components
sno = size(no);
sken = size(ken);
A = zeros(5,2); %corrected for random state 
for i=1:5
    for j=1:2
        A(i,j) = ((-1)^(j+1))*i/10;
    end
end
[IndS, MixM, SepM] = fastica(Zmeas,'numOfIC',2,'approach','symm','stabilization','on','initGuess',A);

%% Find the id at which ken is correlated maximum to the estimated signal
core = zeros(100,1);
for i =1:1000
    dum = ken(i:min(i+sno-1,sken));
    core(i) = corr(IndS(1,1:min(sno,size(dum))).',dum);
end
[val id] = max(abs(core));

%% Change data accordingly and find the correlation coefficient
ken = ken(id:end);
IndS = IndS(:,1:sken-id+1);
no = no(1:sken-id+1);
core2 = corr([ken,no],IndS.');
[M,maxid]=max(abs(core2));

%% Plot figures of the the signals 
figure
subplot(2,2,1)     
plot(ken)
title('Kennedy speech true')
subplot(2,2,3)       
plot(IndS(maxid(1),:))
title('Kennedy speech estimated')
subplot(2,2,2)       
plot(no)
title('No ways true')
subplot(2,2,4)       
plot(IndS(maxid(2),:)) 
title('No ways estimated')
