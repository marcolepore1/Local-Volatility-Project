clc;
clearvars;

spot = 1.18;
T = 1;
disc_fact = 0.99;
disc_fact_for = 0.995;
fwd = spot * disc_fact_for / disc_fact;
mkt_vol = 0.15;

% find K such that blsdelta(K,fwt,T,sigma) = Delta
% recall that X = FZERO(FUN,X0) tries to find a zero of the function FUN near X0
Delta = [10 25 50 75 90];
K = Delta*0;
for i = 1:length(Delta)
    K(i) = fzero(@(Strike) blsdelta(fwd,Strike,0,T,mkt_vol)-(1-Delta(i)/100), fwd);
end

% interpolation grid
k = 0.1:0.01:2;

% undiscounted delta of call options 
% [cd,pd] = blsdelta(so,x,r,t,sig,q)
delta = blsdelta(fwd,k,0,T,mkt_vol);

figure;
plot(K,(1-Delta/100),'o',k,delta,':.');
title(['Black-Scholes Delta Call as function of strike (\sigma=' num2str(mkt_vol*100) '%)']);
